var first = 0
var third = 2
param VnetName_var string = 'az104-05-vnet'

resource peering01 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' =  {
  name: '${VnetName_var}${first}_to_${VnetName_var}${third}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', '${VnetName_var}${first}_to_${VnetName_var}${third}')
    }
  }
}

resource peering_back 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' =  {
  name: '${VnetName_var}${third}_to_${VnetName_var}${first}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', '${VnetName_var}${third}_to_${VnetName_var}${first}}')
    }
  }
}
