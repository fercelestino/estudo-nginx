local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'vectorhub_dev_svc',
    name: 'vectorhub_dev_svc',
    upstream_id: 'vectorhub_dev',
    plugins:
      plugins.proxyRewrite(['^/vectorhub(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
  {
    id: 'vectorhub_prod_svc',
    name: 'vectorhub_prod_svc',
    upstream_id: 'vectorhub_prod',
    plugins:
      plugins.proxyRewrite(['^/vectorhubprod(.*)$', '$1']) +
      plugins.apiBreaker(),
  },
]
