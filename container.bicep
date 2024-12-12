var container1name = 'ftbserver'
var container1image = 'itzg/minecraft-server'

resource minecraftserver 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: 'kschcontainertest'
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: container1name
        properties: {
          environmentVariables: [
            { name: 'ACCEPT_MOJANG_EULA', value: 'TRUE' }
            { name: 'VERSION', value: '1.20.4' } // Minecraft version
            { name: 'FTB_MODPACK_ID', value: '123' } // FTB Neotech
            { name: 'FTB_MODPACK_VERSION_ID', value: '12404' } // FTB Neotech version 1.7.0
            { name: 'PVP', value: 'false' }
            { name: 'MEMORY', value: '8G' }
            { name: 'OPS', value: '24a26761-efb2-4912-a38b-b81dd3f97959' }
          ]
          image: container1image
          resources: {
            requests: {
              cpu: 2
              memoryInGB: json('10')
            }
          }
          ports: [
            {
              port: 80
            }
            {
              port: 25565
            }
          ]
          volumeMounts: [
            {
              name: 'filesharevolume'
              mountPath: '/data'
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'tcp'
          port: 80
        }
        {
          protocol: 'tcp'
          port: 25565
        }
      ]
      dnsNameLabel: 'kschcontainertest'
    }
    volumes: [
      {
        name: 'filesharevolume'
        azureFile: {
          shareName: 'ftbshare'
          storageAccountName: 'kschftb'
          storageAccountKey: storageAccount.listKeys().keys[0].value
        }
      }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: 'kschftb'
}
