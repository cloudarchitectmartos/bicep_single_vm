
param vmName string = 'linuxvmdemo'
param vnetName string = 'vnet1'
param vnetIpPrefix string = '10.0.0.0/24'
param snetName string = 'snet1'
param snetIpPrefix string = '10.0.0.0/26'
param rgLocation string = resourceGroup().location

resource vnet1 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: vnetName
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetIpPrefix
      ]
    }
  }
  tags:{
    Owner: 'Cloud Architect'
  }
}
