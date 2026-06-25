local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_controller_web_c6',
    name: 'victoria_controller_web_c6',
    uri: '/victoria_controller_web_c6/*',
    service_id: 'victoria_controller_web_c6_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_controller_web_multi',
    name: 'victoria_controller_web_multi',
    uri: '/victoria_controller_web_multi/*',
    service_id: 'victoria_controller_web_multi_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_controller_web_servopa',
    name: 'victoria_controller_web_servopa',
    uri: '/victoria_controller_web/*',
    service_id: 'victoria_controller_web_servopa_svc',
    plugins: plugins.limitReq(rate=1, burst=0, allowDegradation=false, policy='redis'),
  },
]
