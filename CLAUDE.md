# CLAUDE.md — Project Context

## What this project is

Jsonnet-based configuration builder for an [APISIX](https://apisix.apache.org/) standalone deployment. Source files under `docker/apisix/src/` are compiled by `./build.sh` into `docker/apisix/dist/apisix.yaml`, which is consumed by the Docker stack.

---

## Directory layout

```
docker/apisix/
  src/
    apisix.jsonnet              ← entry point: assembles upstreams/services/routes
    lib/
      plugins.libsonnet         ← reusable plugin helpers (functions, not objects)
    upstreams/
      <name>.libsonnet          ← one upstream per file
    services/
      <name>_svc.libsonnet      ← one service per file; references upstream by id
    routes/
      <name>.libsonnet          ← one route per file; references service by id
  dist/
    apisix.yaml                 ← generated — do not edit manually
  config.yaml                   ← APISIX runtime config (not generated)
  apisix-sample.yaml            ← reference snapshot
docker/docker-compose.yml
build.sh                        ← runs: jsonnet --string src/apisix.jsonnet -o dist/apisix.yaml
```

---

## Conventions

### Naming
- Upstream id: `<service_slug>` (e.g. `web_middleware_servopa`)
- Service id: `<service_slug>_svc`
- Route id / name: `<service_slug>_<route_slug>`

### Plugin helpers (`lib/plugins.libsonnet`)
Each helper is a **function returning an object fragment**. Combine them with `+`:
```jsonnet
plugins:
  plugins.proxyRewrite([...]) +
  plugins.apiBreaker() +
  plugins.limitCount(10, 60),
```
When adding a new plugin, add a corresponding helper here rather than inlining the plugin object in a route or service file.

### Circuit breaker
`plugins.apiBreaker()` is applied at the **service level** so it covers all routes sharing that upstream. Default config:
- Opens after 3 consecutive failures (500/502/503/504)
- Retries on exponential back-off (2, 4, 8 … s) up to 300 s
- Closes after 3 consecutive successes (200/201/204)
- Returns 503 while the circuit is open

Override any parameter as a named argument:
```jsonnet
plugins.apiBreaker(breakResponseCode=502, unhealthyFailures=5)
```

### Routing pattern for this service
All routes are prefixed with `/victoria_controller_web/`. The `proxy-rewrite` plugin at the service level strips this prefix before forwarding to the upstream.

---

## Build

```bash
./build.sh
```

Requires `jsonnet` on `$PATH`. See [README.md](README.md) for installation instructions.

## Run

```bash
./build.sh && docker compose -f docker/docker-compose.yml up -d
```
