local env = import 'env.libsonnet';

{
  limitCount(count, timeWindow, policy=env.rateLimitPolicy, redisHost=env.redisHost, redisPort=env.redisPort, redisPassword=env.redisPassword):: {
    'limit-count': {
      key_type: 'var',
      key: 'http_x_forwarded_for',
      rejected_code: 429,
      show_limit_quota_header: true,
      count: count,
      time_window: timeWindow,
      policy: policy,
    } + (if policy == 'redis' then {
      redis_host: redisHost,
      redis_port: redisPort,
      redis_password: redisPassword,
    } else {}),
  },

  fileLogger(path):: {
    'file-logger': {
      path: path,
    },
  },

  proxyRewrite(regexUri):: {
    'proxy-rewrite': {
      regex_uri: regexUri,
    },
  },

  // Leaky-bucket rate limiter — analogous to nginx limit_req rate=Xr/s burst=Y.
  // Uses Redis so limits are shared across APISIX workers/nodes.
  // Redis connection defaults come from the active envs/*.env file.
  limitReq(rate=3, burst=5, allowDegradation=true, policy=env.rateLimitPolicy, redisHost=env.redisHost, redisPort=env.redisPort, redisPassword=env.redisPassword):: {
    'limit-req': {
      rate: rate,
      burst: burst,
      key_type: 'var',
      key: 'http_x_forwarded_for',
      rejected_code: 429,
      policy: policy,
      allow_degradation: allowDegradation,
    } + (if policy == 'redis' then {
      redis_host: redisHost,
      redis_port: redisPort,
      redis_password: redisPassword,
    } else {}),
  },

  // Concurrency limiter — controls simultaneous in-flight connections.
  // Uses Redis so the limit is shared across APISIX workers/nodes.
  limitConn(conn=10, burst=2, defaultConnDelay=0.1, redisHost=env.redisHost, redisPort=env.redisPort, redisPassword=env.redisPassword):: {
    'limit-conn': {
      conn: conn,
      burst: burst,
      default_conn_delay: defaultConnDelay,
      key_type: 'var',
      key: 'remote_addr',
      rejected_code: 429,
      policy: 'redis',
      redis_host: redisHost,
      redis_port: redisPort,
      redis_password: redisPassword,
    },
  },

  opentelemetry():: {
    opentelemetry: {
      sampler: { name: 'always_on' },
    },
  },

  prometheus():: {
    prometheus: {},
  },

  // Circuit breaker: opens after `unhealthyFailures` consecutive errors, retries on 2^n seconds
  // up to `maxBreakerSec`; closes after `healthySuccesses` consecutive healthy responses.
  apiBreaker(
    breakResponseCode=503,
    maxBreakerSec=300,
    unhealthyStatuses=[500, 502, 503, 504],
    unhealthyFailures=3,
    healthyStatuses=[200, 201, 204, 400, 401, 403, 404, 405, 409, 422],
    healthySuccesses=3,
  ):: {
    'api-breaker': {
      break_response_code: breakResponseCode,
      max_breaker_sec: maxBreakerSec,
      unhealthy: {
        http_statuses: unhealthyStatuses,
        failures: unhealthyFailures,
      },
      healthy: {
        http_statuses: healthyStatuses,
        successes: healthySuccesses,
      },
    },
  },
}
