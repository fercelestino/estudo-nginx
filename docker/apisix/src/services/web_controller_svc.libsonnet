local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'victoria_controller_web_servopa_svc',
    name: 'victoria_controller_web_servopa_svc',
    upstream_id: 'victoria_controller_web_servopa',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_web(.*)$', '$1']) +
      // DEBUG: reduced thresholds for circuit-breaker testing.
      // Prod defaults: unhealthyFailures=3, healthySuccesses=3, maxBreakerSec=300.
      // Restore before merging to production.
      plugins.apiBreaker(unhealthyFailures=2, healthySuccesses=2, maxBreakerSec=30) +
      plugins.opentelemetry() +
      plugins.prometheus() +
      // DEBUG: per-request log inside the container at /usr/local/apisix/logs/cb_debug.log.
      // Tail with: docker compose exec apisix tail -f /usr/local/apisix/logs/cb_debug.log
      // Remove for production.
      plugins.fileLogger('/usr/local/apisix/logs/cb_debug.log'),

  },
  {
    id: 'victoria_controller_web_c6_svc',
    name: 'victoria_controller_web_c6_svc',
    upstream_id: 'victoria_controller_web_c6',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_web_c6(.*)$', '$1']) +
      plugins.apiBreaker() +
      plugins.opentelemetry() +
      plugins.prometheus(),
  },
  {
    id: 'victoria_controller_web_multi_svc',
    name: 'victoria_controller_web_multi_svc',
    upstream_id: 'victoria_controller_web_multi',
    plugins:
      plugins.proxyRewrite(['^/victoria_controller_web_multi(.*)$', '$1']) +
      plugins.apiBreaker() +
      plugins.opentelemetry() +
      plugins.prometheus(),
  },
]
