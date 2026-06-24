# APISIX Standalone Config Build

> For Claude Code context (project structure, conventions, circuit breaker config): see [CLAUDE.md](CLAUDE.md).

This project uses [Jsonnet](https://jsonnet.org/) to manage APISIX's `apisix.yaml` as modular source files. The build step merges them into a single YAML file consumed by Docker.

## How it works

```
envs/
  dev.env                     ← DEV hostnames and ports
  prod.env                    ← PROD hostnames and ports

docker/apisix/src/            ← edit these
  apisix.jsonnet              ← main entry point (imports everything)
  lib/
    env.libsonnet             ← reads injected env vars; single source of truth for all hosts/ports
    plugins.libsonnet         ← reusable plugin helpers
  upstreams/                  ← one file per upstream; imports env.libsonnet for host values
  services/                   ← one file per service
  routes/                     ← one file per route

docker/apisix/dist/
  apisix.yaml                 ← generated output (do not edit manually)
```

`build.sh` reads the selected `envs/*.env` file, then calls `jsonnet` with `--ext-str` flags that
inject every host/port as an external variable. `env.libsonnet` exposes those variables as typed
fields so every upstream file can reference them by name.

---

## Installing Jsonnet

### macOS

```bash
brew install jsonnet
```

### Ubuntu / Debian

```bash
sudo apt-get update
sudo apt-get install -y jsonnet
```

If the package is not available or outdated, install from source:

```bash
sudo apt-get install -y build-essential
git clone https://github.com/google/jsonnet.git
cd jsonnet && make
sudo mv jsonnet /usr/local/bin/
```

### Windows (WSL)

Inside your WSL terminal (Ubuntu):

```bash
sudo apt-get update
sudo apt-get install -y jsonnet
```

Verify the installation on any platform:

```bash
jsonnet --version
```

---

## Building

```bash
# DEV (default)
./build.sh

# PROD
ENV=prod ./build.sh
```

`build.sh` sources `envs/${ENV}.env` before running `jsonnet`, so no shell environment setup is
required — just pick a name.

---

## Starting the stack

```bash
# DEV
./deploy.sh

# PROD
ENV=prod ./deploy.sh
```

`deploy.sh` calls `build.sh` with the same `ENV` and then runs `docker compose up -d`.

You can still run the two steps separately if needed:

```bash
ENV=prod ./build.sh
docker compose -f docker/docker-compose.yml up -d
```

---

## Environment files

Each file in `envs/` defines hostnames and ports for one environment.

**`envs/dev.env`**
```bash
CONTROLLER_SERVER=victoriadev.consorcio.local
VECTORHUB_SERVER=victoriadev.consorcio.local
API_SERVER=victoriadev.consorcio.local
VICTORIAPRO_SERVER=victoriaprodev.consorcio.local
REDIS_HOST=victoriadev.consorcio.local
REDIS_PORT=6379
```

**`envs/prod.env`**
```bash
CONTROLLER_SERVER=victoria.consorcio.local
VECTORHUB_SERVER=victoria.consorcio.local
API_SERVER=victoria.consorcio.local
VICTORIAPRO_SERVER=victoriapro.consorcio.local
REDIS_HOST=victoria.consorcio.local
REDIS_PORT=6379
```

`build.sh` passes every variable to `jsonnet` via `--ext-str`. The Jsonnet side reads them all in
`lib/env.libsonnet`:

```jsonnet
// lib/env.libsonnet
{
  controllerServer: std.extVar('CONTROLLER_SERVER'),
  vectorhubServer:  std.extVar('VECTORHUB_SERVER'),
  apiServer:        std.extVar('API_SERVER'),
  victoriaproServer: std.extVar('VICTORIAPRO_SERVER'),
  redisHost:        std.extVar('REDIS_HOST'),
  redisPort:        std.parseInt(std.extVar('REDIS_PORT')),
}
```

Upstream files import `env.libsonnet` and reference its fields instead of hardcoding hostnames:

```jsonnet
local env = import '../lib/env.libsonnet';

{
  id: 'my_upstream',
  nodes: [{ host: env.apiServer, port: 3000, weight: 1 }],
  ...
}
```

---

## Adding a new hostname or server group

Follow these three steps whenever a new backend host needs to be configurable per environment.

### 1 — Add the variable to every env file

`envs/dev.env`:
```bash
MY_NEW_SERVER=myservice-dev.consorcio.local
```

`envs/prod.env`:
```bash
MY_NEW_SERVER=myservice.consorcio.local
```

### 2 — Expose it in `lib/env.libsonnet`

```jsonnet
{
  // ... existing fields ...
  myNewServer: std.extVar('MY_NEW_SERVER'),
}
```

### 3 — Wire it in `build.sh`

Add one line inside the `jsonnet` call:

```bash
jsonnet --string "$SRC" -o "$OUT" \
  ...existing flags... \
  --ext-str MY_NEW_SERVER="${MY_NEW_SERVER}"
```

### 4 — Use it in the upstream file

```jsonnet
local env = import '../lib/env.libsonnet';

{
  id: 'my_new_upstream',
  nodes: [{ host: env.myNewServer, port: 8080, weight: 1 }],
  ...
}
```

> **Rule:** never hardcode a hostname or port that differs between environments. Always go through
> `env.libsonnet`. Ports that are the same in all environments (e.g. 6379 for Redis) may be
> hardcoded in the upstream file, but the host must always come from `env.libsonnet`.

---

## Adding a new upstream, service, and route

### Upstream

Create `docker/apisix/src/upstreams/my_service.libsonnet`:

```jsonnet
local env = import '../lib/env.libsonnet';

{
  id: 'my_service',
  name: 'my_service',
  desc: 'my_service',
  scheme: 'http',
  nodes: [{ host: env.apiServer, port: 3010, weight: 1 }],
  type: 'roundrobin',
  pass_host: 'node',
}
```

Import it in `docker/apisix/src/apisix.jsonnet`:

```jsonnet
local my_service_upstream = import 'upstreams/my_service.libsonnet';
local upstreams = [my_service_upstream, ...existing...];
```

### Service

Create `docker/apisix/src/services/my_service_svc.libsonnet`:

```jsonnet
local plugins = import '../lib/plugins.libsonnet';

{
  id: 'my_service_svc',
  name: 'my_service_svc',
  upstream_id: 'my_service',
  plugins:
    plugins.proxyRewrite(['^/my_service(.*)$', '$1']) +
    plugins.apiBreaker(),
}
```

### Route

Create `docker/apisix/src/routes/my_service.libsonnet`:

```jsonnet
local plugins = import '../lib/plugins.libsonnet';

[
  {
    id: 'my_service_list',
    name: 'my_service_list',
    uri: '/my_service/*',
    service_id: 'my_service_svc',
    plugins: plugins.limitReq(),
  },
]
```

Then rebuild:

```bash
./build.sh
```

---

## Adding a new plugin helper

Add a new function to `docker/apisix/src/lib/plugins.libsonnet`:

```jsonnet
myPlugin(option):: {
  'my-plugin': {
    option: option,
  },
},
```

Use it in any route or service file:

```jsonnet
local plugins = import '../lib/plugins.libsonnet';
plugins.myPlugin('value')
```

If the plugin needs a host or port that varies by environment, accept it as a parameter with an
`env.*` default:

```jsonnet
local env = import 'env.libsonnet';  // same lib/ directory

myPlugin(host=env.myNewServer, port=9000):: {
  'my-plugin': { host: host, port: port },
},
```

---

## Jenkins integration

Pass `ENV` as a build parameter (e.g. a `choice` parameter named `ENV` with values `dev` / `prod`):

```groovy
stage('Build APISIX config') {
    steps {
        sh "ENV=${params.ENV} ./build.sh"
    }
}
stage('Deploy') {
    steps {
        sh 'docker compose -f docker/docker-compose.yml up -d'
    }
}
```
