targetScope = 'subscription'

@description('resPrefix')
param resPrefix string = 'az104-05'

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

var first  = 0
var second = 1
var third = 2
param username string
param password string
var subnetName = 'subnet0'
param VnetName_var string = 'az104-05-vnet'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name:'${resPrefix}-rg1'
  location: location1
}

module startCreating './module/startcreating.bicep' = {
  name: 'startCreating'
  scope: rg 
  params: {
  location1: location1
  location2: location2
  adminPassword: password
  adminUsername: username
  }
}



resource VnetName 'Microsoft.Network/virtualNetworks@2021-07-01' = [for (item, i) in locationNames: {
  name: concat(VnetName_var, i)
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

module peering01 'module/peering01.bicep' = {
  name: '${VnetName_var}${first}'
  scope: rg
  }

module peering02 'module/peering02.bicep' = {
  name: '${VnetName_var}${second}'
  scope: rg
  }

module peering12 'module/peering12.bicep' = {
  name: '${VnetName_var}${third}'
  scope: rg
  }



