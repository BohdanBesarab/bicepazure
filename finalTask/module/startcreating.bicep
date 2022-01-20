@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

@description('First Azure Region')
param location1 string = 'westeurope'

@description('Second Azure Region')
param location2 string = 'eastus'

@description('Location')
param locationNames array = [
'${location1}'
'${location1}'
'${location2}'
]

var vmName_var = 'az104-05-vm'
@description('Virtual machine size')
param vmSize string = 'Standard_D2s_v3'
var subnetName = 'subnet0'
param VnetName_var string = 'az104-05-vnet'
var pipName_var = 'az104-05-pip'
var nsgName_var = 'az104-05-nsg'
var nicName_var = 'az104-05-nic'


resource vmName 'Microsoft.Compute/virtualMachines@2021-07-01' = [for (item, i) in locationNames: {
    name: concat(vmName_var, i)
    location: item
    properties: {
      osProfile: {
        computerName: concat(vmName_var, i)
        adminUsername: adminUsername
        adminPassword: adminPassword
        windowsConfiguration: {
          provisionVmAgent: 'true'
        }
      }
      hardwareProfile: {
        vmSize: vmSize
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2019-Datacenter'
          version: 'latest'
        }
        osDisk: {
          createOption: 'fromImage'
        }
        dataDisks: []
      }
      networkProfile: {
        networkInterfaces: [
          {
            properties: {
              primary: true
            }
            id: resourceId('Microsoft.Network/networkInterfaces', concat(nicName_var, i))
          }
        ]
      }
    }
    
  }]
  resource nicName 'Microsoft.Network/networkInterfaces@2021-05-01' = [for (item, i) in locationNames: {
    name: concat(nicName_var, i)
    location: item
    properties: {
      ipConfigurations: [
        {
          name: 'ipconfig1'
          properties: {
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', concat(VnetName_var, i), subnetName)
            }
            privateIPAllocationMethod: 'Dynamic'
            publicIpAddress: {
              id: resourceId('Microsoft.Network/publicIpAddresses', concat(pipName_var, i))
            }
          }
        }
      ]
      networkSecurityGroup: {
        id: resourceId('Microsoft.Network/networkSecurityGroups', concat(nsgName_var, i))
      }
    }
  }]

  resource pipName 'Microsoft.Network/publicIpAddresses@2021-05-01' = [for (item, i) in locationNames: {
    name: concat(pipName_var, i)
    location: item
    properties: {
      publicIpAllocationMethod: 'Dynamic'
    }
  }]
  
  resource nsgName 'Microsoft.Network/networkSecurityGroups@2021-05-01' = [for (item, i) in locationNames: {
    name: concat(nsgName_var, i)
    location: item
    properties: {
      securityRules: [
        {
          name: 'default-allow-rdp'
          properties: {
            priority: 1000
            sourceAddressPrefix: '*'
            protocol: 'Tcp'
            destinationPortRange: '3389'
            access: 'Allow'
            direction: 'Inbound'
            sourcePortRange: '*'
            destinationAddressPrefix: '*'
          }
        }
      ]
    }
  }]

