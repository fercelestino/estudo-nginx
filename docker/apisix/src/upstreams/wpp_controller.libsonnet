local env = import '../lib/env.libsonnet';

[
  {
    id: 'victoria_controller',
    name: 'victoria_controller',
    desc: 'victoria_controller',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8091, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_controller_sf',
    name: 'victoria_controller_sf',
    desc: 'victoria_controller_sf',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8093, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_controller_pconn_c6',
    name: 'victoria_controller_pconn_c6',
    desc: 'victoria_controller_pconn_c6',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8094, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_controller_pconn_dev',
    name: 'victoria_controller_pconn_dev',
    desc: 'victoria_controller_pconn_dev',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8096, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
]
