targetScope = 'subscription'

@description('Resource prefix')
param resourcePrefix string ='AzureCamp'

@description('Location')
@allowed([
  'eastus'
  'euwest'
])
param location string = 'eastus'

param storageAccounts array = [
  'accounta'
  'accountb'
  'fileservice'
]


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
name: '${resourcePrefix}-rg'
location: location
} 

module sa 'module/storageAcoount.bicep' = [for storageAccount in storageAccounts: {
    scope: rg
    name: storageAccount
    params: {
    accountName: storageAccount
    }
}]

