local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_controller_web_servopa_svc',
    name: 'victoria_controller_web_servopa_svc',
    upstream_id: 'victoria_controller_web_servopa',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_web(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'victoria_controller_web_c6_svc',
    name: 'victoria_controller_web_c6_svc',
    upstream_id: 'victoria_controller_web_c6',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_web_c6(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'victoria_controller_web_multi_svc',
    name: 'victoria_controller_web_multi_svc',
    upstream_id: 'victoria_controller_web_multi',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_web_multi(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
]
