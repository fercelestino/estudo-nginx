local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_api_v1_svc',
    name: 'victoria_api_v1_svc',
    upstream_id: 'victoria_api_v1',
    plugins:
      plugins.proxyRewrite(['^/victoria_api_v1(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'victoria_api_v2_svc',
    name: 'victoria_api_v2_svc',
    upstream_id: 'victoria_api_v2',
    plugins:
      plugins.proxyRewrite(['^/victoria_api_v2(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'victoria_api_svc',
    name: 'victoria_api_svc',
    upstream_id: 'victoria_api',
    plugins:
      plugins.proxyRewrite(['^/victoria_api(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'victoria_admin_svc',
    name: 'victoria_admin_svc',
    upstream_id: 'victoria_admin',
    plugins:
      plugins.proxyRewrite(['^/victoria_admin(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
]
