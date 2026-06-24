local env = import '../lib/env.libsonnet';

[
  {
    id: 'victoriapro_inference',
    name: 'victoriapro_inference',
    desc: 'victoriapro_inference',
    scheme: 'http',
    nodes: [{ host: env.victoriaproServer, port: 8444, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoriapro_api',
    name: 'victoriapro_api',
    desc: 'victoriapro_api',
    scheme: 'http',
    nodes: [{ host: env.apiServer, port: 3008, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
]
