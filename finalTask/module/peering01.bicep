var first = 0
var second = 1
param VnetName_var string = 'az104-05-vnet'

resource peering01 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' =  {
  name: '${VnetName_var}${first}_to_${VnetName_var}${second}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', '${VnetName_var}${first}_to_${VnetName_var}${second}')
    }
  }
}

resource peering_back 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' =  {
  name: toLower('${VnetName_var}${second}_to_${VnetName_var}${first}')
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', '${VnetName_var}${second}_to_${VnetName_var}${first}}')
    }
  }
}
