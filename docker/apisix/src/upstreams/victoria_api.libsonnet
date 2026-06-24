local env = import '../lib/env.libsonnet';

[
  {
    id: 'victoria_api_v1',
    name: 'victoria_api_v1',
    desc: 'victoria_api_v1',
    scheme: 'http',
    nodes: [{ host: env.apiServer, port: 3006, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_api_v2',
    name: 'victoria_api_v2',
    desc: 'victoria_api_v2',
    scheme: 'http',
    nodes: [{ host: env.apiServer, port: 3002, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_api',
    name: 'victoria_api',
    desc: 'victoria_api',
    scheme: 'http',
    nodes: [{ host: env.apiServer, port: 3000, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_admin',
    name: 'victoria_admin',
    desc: 'victoria_admin',
    scheme: 'http',
    nodes: [{ host: env.apiServer, port: 8080, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
]
