local env = import '../lib/env.libsonnet';

local activeHealthCheck = {
  active: {
    type: 'http',
    http_path: '/health',
    healthy: {
      interval: 2,
      successes: 2,
      http_statuses: [200, 204],
    },
    unhealthy: {
      interval: 1,
      http_failures: 3,
      http_statuses: [429, 500, 502, 503, 504],
    },
  },
};

[
  {
    id: 'victoria_controller_web_servopa',
    name: 'victoria_controller_web_servopa',
    desc: 'victoria_controller_web_servopa',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8092, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
  {
    id: 'victoria_controller_web_c6',
    name: 'victoria_controller_web_c6',
    desc: 'victoria_controller_web_c6',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8095, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
  {
    id: 'victoria_controller_web_multi',
    name: 'victoria_controller_web_multi',
    desc: 'victoria_controller_web_multi',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8097, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
]
