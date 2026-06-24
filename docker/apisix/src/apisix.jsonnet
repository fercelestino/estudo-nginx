local env = import 'lib/env.libsonnet';

local web_middleware_upstream = import 'upstreams/web_middleware_servopa.libsonnet';
local victoria_api_upstreams = import 'upstreams/victoria_api.libsonnet';
local victoriapro_api_upstreams = import 'upstreams/victoriapro_api.libsonnet';
local vectorhub_upstreams = import 'upstreams/vectorhub.libsonnet';
local web_controller_upstreams = import 'upstreams/web_controller.libsonnet';
local wpp_controller_upstreams = import 'upstreams/wpp_controller.libsonnet';

local upstreams =
  [web_middleware_upstream] +
  victoria_api_upstreams +
  victoriapro_api_upstreams +
  vectorhub_upstreams +
  web_controller_upstreams +
  wpp_controller_upstreams;

local web_middleware_svc = import 'services/web_middleware_servopa_svc.libsonnet';
local victoria_api_svcs = import 'services/victoria_api_svc.libsonnet';
local victoriapro_api_svcs = import 'services/victoriapro_api_svc.libsonnet';
local vectorhub_svcs = import 'services/vectorhub_svc.libsonnet';
local web_controller_svcs = import 'services/web_controller_svc.libsonnet';
local wpp_controller_svcs = import 'services/wpp_controller_svc.libsonnet';

local services =
  [web_middleware_svc] +
  victoria_api_svcs +
  victoriapro_api_svcs +
  vectorhub_svcs +
  web_controller_svcs +
  wpp_controller_svcs;

local victoria_api_routes = import 'routes/victoria_api.libsonnet';
local victoriapro_api_routes = import 'routes/victoriapro_api.libsonnet';
local vectorhub_routes = import 'routes/vectorhub.libsonnet';
local web_controller_routes = import 'routes/web_controller.libsonnet';
local wpp_controller_routes = import 'routes/wpp_controller.libsonnet';

local routes =
  victoria_api_routes +
  victoriapro_api_routes +
  vectorhub_routes +
  web_controller_routes +
  wpp_controller_routes;

std.manifestYamlDoc(
  {
    upstreams: upstreams,
    services: services,
    routes: routes,
    plugin_metadata: [
      {
        id: 'opentelemetry',
        trace_id_source: 'x-request-id',
        resource: {
          'service.name': 'apisix-victoria-gateway',
        },
        collector: {
          address: env.otelEndpoint,
          request_uri: '/v1/traces',
          request_timeout: 3,
        },
      },
    ],
  },
  quote_keys=false
)
