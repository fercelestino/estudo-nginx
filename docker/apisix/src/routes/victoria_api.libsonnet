local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_api_v1',
    name: 'victoria_api_v1',
    uri: '/victoria/api/v1/*',
    service_id: 'victoria_api_v1_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_api_v2',
    name: 'victoria_api_v2',
    uri: '/victoria/api/v2/*',
    service_id: 'victoria_api_v2_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_api',
    name: 'victoria_api',
    uri: '/victoria/api/*',
    service_id: 'victoria_api_svc',
    plugins: plugins.limitReq(),
  },
  {
    id: 'victoria_admin',
    name: 'victoria_admin',
    uri: '/victoria/admin*',
    service_id: 'victoria_admin_svc',
    plugins: plugins.limitReq(),
  },
]
