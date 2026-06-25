local env = import 'lib/env.libsonnet';

std.manifestYamlDoc(
  {
    deployment: {
      role: 'data_plane',
      role_data_plane: {
        config_provider: 'yaml',
      },
    },
    nginx_config: {
      error_log_level: 'debug',
      http: {
        access_log_format: '$time_local $remote_addr - "$request" $status up_status=$upstream_status up_time=$upstream_response_time',
        access_log_format_escape: 'default',
      },
    },
    plugins: [
      'api-breaker',
      'proxy-rewrite',
      'limit-req',
      'limit-count',
      'limit-conn',
      'file-logger',
      'opentelemetry',
      'prometheus',
    ],
    plugin_attr: {
      opentelemetry: {
        collector: {
          address: env.otelEndpoint,
          request_uri: '/v1/traces',
          request_timeout: 3,
        },
      },
      prometheus: {
        export_uri: '/apisix/prometheus/metrics',
        export_addr: {
          ip: '0.0.0.0',
          port: 9091,
        },
      },
    },
  },
  quote_keys=false
)
