// Environment-specific values injected by build.sh via --ext-str.
// Change values by editing envs/dev.env (or envs/prod.env) and running ./build.sh ENV=<name>.
{
  controllerServer: std.extVar('CONTROLLER_SERVER'),
  vectorhubServer: std.extVar('VECTORHUB_SERVER'),
  apiServer: std.extVar('API_SERVER'),
  victoriaproServer: std.extVar('VICTORIAPRO_SERVER'),
  rateLimitPolicy: std.extVar('RATE_LIMIT_POLICY'),
  redisHost: std.extVar('REDIS_HOST'),
  redisPort: std.parseInt(std.extVar('REDIS_PORT')),
  redisPassword: std.extVar('REDIS_PASSWORD'),
  otelEndpoint: std.extVar('OTEL_ENDPOINT'),
}
