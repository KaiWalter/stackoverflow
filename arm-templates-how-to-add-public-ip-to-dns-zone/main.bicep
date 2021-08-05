// https://stackoverflow.com/questions/67701330/arm-templates-how-to-add-public-ip-to-dns-zone

param rg_location string = resourceGroup().location

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  location: rg_location
  name: 'pip-example'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    dnsSettings: {
      domainNameLabel: 'publicipname'
      fqdn: 'publicipname.customdomain.com'
    }
    publicIPAllocationMethod: 'Static'
  }
}

resource dns 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'customdomain.com'
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

resource dnsEntry 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  name: 'publicipname'
  parent: dns
  properties: {
    // targetResource: {
    //   id: publicIp.id
    // }
    TTL: 3600
    ARecords: [
      {
        ipv4Address: publicIp.properties.ipAddress
      }
    ]
  }
}
