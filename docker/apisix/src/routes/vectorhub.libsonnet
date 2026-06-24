local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'vectorhub_dev_ws',
    name: 'vectorhub_dev_ws',
    uri: '/vectorhub/ws/*',
    service_id: 'vectorhub_dev_svc',
    enable_websocket: true,
    plugins: plugins.limitReq(),
  },
  {
    id: 'vectorhub_dev',
    name: 'vectorhub_dev',
    uri: '/vectorhub/*',
    service_id: 'vectorhub_dev_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'vectorhub_prod_ws',
    name: 'vectorhub_prod_ws',
    uri: '/vectorhubprod/ws/*',
    service_id: 'vectorhub_prod_svc',
    enable_websocket: true,
    plugins: plugins.limitReq(),
  },
  {
    id: 'vectorhub_prod',
    name: 'vectorhub_prod',
    uri: '/vectorhubprod/*',
    service_id: 'vectorhub_prod_svc',
    plugins: plugins.limitReq(),
  },
]
