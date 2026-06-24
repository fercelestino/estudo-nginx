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
    id: 'victoria_controller',
    name: 'victoria_controller',
    desc: 'victoria_controller',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8091, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
  {
    id: 'victoria_controller_sf',
    name: 'victoria_controller_sf',
    desc: 'victoria_controller_sf',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8093, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
  {
    id: 'victoria_controller_pconn_c6',
    name: 'victoria_controller_pconn_c6',
    desc: 'victoria_controller_pconn_c6',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8094, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
  {
    id: 'victoria_controller_pconn_dev',
    name: 'victoria_controller_pconn_dev',
    desc: 'victoria_controller_pconn_dev',
    scheme: 'http',
    nodes: [{ host: env.controllerServer, port: 8096, weight: 1 }],
    type: 'roundrobin',
    pass_host: 'node',
    checks: activeHealthCheck,
  },
]
