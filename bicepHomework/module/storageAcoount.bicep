param accountName string 

var accountNameFull = toLower('${accountName}${uniqueString(resourceGroup().id)}')


var saKind = accountName == 'fileservice' ? 'FileStorage' : 'StorageV2'

resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name : accountNameFull
  location: resourceGroup().location
  sku:{
    name: 'Standard_LRS'
  }
  kind: saKind
}
