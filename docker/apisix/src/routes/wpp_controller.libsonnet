local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_controller_sf',
    name: 'victoria_controller_sf',
    uri: '/victoria_controller_sf/*',
    service_id: 'victoria_controller_sf_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_controller_pconn_c6',
    name: 'victoria_controller_pconn_c6',
    uri: '/victoria_controller_pconn/c6/*',
    service_id: 'victoria_controller_pconn_c6_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_controller_pconn_dev',
    name: 'victoria_controller_pconn_dev',
    uri: '/victoria_controller_pconn/dev/*',
    service_id: 'victoria_controller_pconn_dev_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_controller',
    name: 'victoria_controller',
    uri: '/victoria_controller/*',
    service_id: 'victoria_controller_svc',
    plugins: plugins.limitReq(),
  },
]
