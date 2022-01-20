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

var subnetName = 'subnet0'
var nicName_var = 'az104-05-nic'
param VnetName_var string = 'az104-05-vnet'
var pipName_var = 'az104-05-pip'
var nsgName_var = 'az104-05-nsg'

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
