local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_controller_svc',
    name: 'victoria_controller_svc',
    upstream_id: 'victoria_controller',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller(.*)$', '$1']) +
      plugins.apiBreaker() +
      plugins.opentelemetry() +
      plugins.prometheus(),
  },
  {
    id: 'victoria_controller_sf_svc',
    name: 'victoria_controller_sf_svc',
    upstream_id: 'victoria_controller_sf',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_sf(.*)$', '$1']) +
      plugins.apiBreaker() +
      plugins.opentelemetry() +
      plugins.prometheus(),
  },
  {
    id: 'victoria_controller_pconn_c6_svc',
    name: 'victoria_controller_pconn_c6_svc',
    upstream_id: 'victoria_controller_pconn_c6',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_pconn_c6(.*)$', '$1']) +
      plugins.apiBreaker() +
      plugins.opentelemetry() +
      plugins.prometheus(),
  },
  {
    id: 'victoria_controller_pconn_dev_svc',
    name: 'victoria_controller_pconn_dev_svc',
    upstream_id: 'victoria_controller_pconn_dev',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_pconn_dev(.*)$', '$1']) +
      plugins.apiBreaker() +
      plugins.opentelemetry() +
      plugins.prometheus(),
  },
]
