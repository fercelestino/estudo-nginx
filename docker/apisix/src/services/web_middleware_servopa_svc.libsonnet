local plugins = import '../lib/plugins.libsonnet';

{
  id: 'web_middleware_servopa_svc',
  name: 'web_middleware_servopa_svc',
  upstream_id: 'web_middleware_servopa',
  plugins:
    plugins.proxyRewrite(['^/victoria_controller_web(.*)$', '$1']) +
    // DEBUG: reduced thresholds for circuit-breaker testing.
    // Prod defaults: unhealthyFailures=3, healthySuccesses=3, maxBreakerSec=300.
    // Restore before merging to production.
    plugins.apiBreaker(unhealthyFailures=2, healthySuccesses=2, maxBreakerSec=30) +
    // DEBUG: per-request log inside the container at /usr/local/apisix/logs/cb_debug.log.
    // Tail with: docker compose exec apisix tail -f /usr/local/apisix/logs/cb_debug.log
    // Remove for production.
    plugins.fileLogger('/usr/local/apisix/logs/cb_debug.log'),
}
