local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoriapro_inference',
    name: 'victoriapro_inference',
    uri: '/victoriapro/inference/*',
    service_id: 'victoriapro_inference_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoriapro_api_v1',
    name: 'victoriapro_api_v1',
    uri: '/victoriapro/api/v1/*',
    service_id: 'victoriapro_api_svc',
    plugins: plugins.limitReq(),
  },
]
