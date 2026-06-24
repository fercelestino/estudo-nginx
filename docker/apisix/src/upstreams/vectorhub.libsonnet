local env = import '../lib/env.libsonnet';

[
  {
    id: 'vectorhub_dev',
    name: 'vectorhub_dev',
    desc: 'vectorhub_dev',
    scheme: 'http',
    nodes: [{ host: env.vectorhubServer, port: 8082, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'vectorhub_prod',
    name: 'vectorhub_prod',
    desc: 'vectorhub_prod',
    scheme: 'http',
    nodes: [{ host: 'victoria.consorcio.local', port: 8089, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
]
