@description('Admin username')
param adminUsername string = 'bohdan.besarab'

@description('Admin password')
@minLength(8)
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

@description('Virtual machine size')
param vmSize string = 'Standard_D2s_v3'

@description('Name vitrual networks')
param VnetName_var string = 'az104-05-vnet'

var vmName_var = 'az104-05-vm'
var subnetName = 'subnet0'
var pipName_var = 'az104-05-pip'
var nsgName_var = 'az104-05-nsg'
var nicName_var = 'az104-05-nic'

resource vmName 'Microsoft.Compute/virtualMachines@2021-07-01' = [for (item, i) in locationNames: {
    name: '${vmName_var}${i}'
    location: item
    properties: {
      osProfile: {
        computerName: '${vmName_var}${i}'
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
          createOption: 'FromImage'
        }
        dataDisks: []
      }
      networkProfile: {
        networkInterfaces: [
          {
            properties: {
              primary: true
            }
            id: resourceId('Microsoft.Network/networkInterfaces', '${nicName_var}${i}')
          }
        ]
      }
    }
    
  }]

  resource VnetName 'Microsoft.Network/virtualNetworks@2021-05-01' = [for (item, i) in locationNames: {
    name: '${VnetName_var}${i}'
    location: item
    properties: {
      addressSpace: {
        addressPrefixes: [
          '10.5${i}.0.0/22'
        ]
      }
      subnets: [
        {
          name: subnetName
          properties: {
            addressPrefix: '10.5${i}.0.0/24'
          }
        }
      ]
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
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', '${VnetName_var}${i}', subnetName)
            }
            privateIPAllocationMethod: 'Dynamic'
            publicIpAddress: {
              id: resourceId('Microsoft.Network/publicIpAddresses', '${pipName_var}${i}')
            }
          }
        }
      ]
      networkSecurityGroup: {
        id: resourceId('Microsoft.Network/networkSecurityGroups','${nsgName_var}${i}')
      }
    }
  }]

  resource pipName 'Microsoft.Network/publicIpAddresses@2021-05-01' = [for (item, i) in locationNames: {
    name: '${pipName_var}${i}'
    location: item
    properties: {
      publicIpAllocationMethod: 'Dynamic'
    }
  }]
  
  resource nsgName 'Microsoft.Network/networkSecurityGroups@2021-05-01' = [for (item, i) in locationNames: {
    name: '${nsgName_var}${i}'
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

