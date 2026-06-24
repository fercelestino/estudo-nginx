local env = import '../lib/env.libsonnet';

[
  {
    id: 'victoria_controller_web_servopa',
    name: 'victoria_controller_web_servopa',
    desc: 'victoria_controller_web_servopa',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8092, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_controller_web_c6',
    name: 'victoria_controller_web_c6',
    desc: 'victoria_controller_web_c6',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8095, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
  {
    id: 'victoria_controller_web_multi',
    name: 'victoria_controller_web_multi',
    desc: 'victoria_controller_web_multi',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8097, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
  },
]
