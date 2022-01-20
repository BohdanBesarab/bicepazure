targetScope = 'subscription'

@description('resPrefix')
param resPrefix string = 'az104-05'

@description('First Azure Region')
param location1 string = 'westeurope'

@description('Second Azure Region')
param location2 string = 'eastus'

@description('Admin username')
param adminUsername string = 'bohdan.besarab'

@description('Admin password')
@minLength(8)
@secure()
param adminPassword string ='123.AskinG.324'

var first  = 0
var second = 1
var third = 2

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
  adminPassword: adminPassword
  adminUsername: adminUsername
  }
}


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



