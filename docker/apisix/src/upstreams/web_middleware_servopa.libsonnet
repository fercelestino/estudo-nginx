local env = import '../lib/env.libsonnet';

{
  id: 'web_middleware_servopa',
  name: 'web_middleware_servopa',
  desc: 'web_middleware_servopa.consorcioservopa.com.br',
  scheme: 'http',
  nodes: [
    {
      host: env.controllerServer,
      port: 8092,
      weight: 2,
    },
  ],
  type: 'roundrobin',
  pass_host: 'node',
}
