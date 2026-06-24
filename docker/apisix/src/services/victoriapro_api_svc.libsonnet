local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoriapro_inference_svc',
    name: 'victoriapro_inference_svc',
    upstream_id: 'victoriapro_inference',
    plugins:
      plugins.proxyRewrite(['^/victoriapro_inference(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'victoriapro_api_svc',
    name: 'victoriapro_api_svc',
    upstream_id: 'victoriapro_api',
    plugins:
      plugins.proxyRewrite(['^/victoriapro_api(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
]
