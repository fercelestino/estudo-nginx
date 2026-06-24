# APISIX Standalone Config Build

> For Claude Code context (project structure, conventions, circuit breaker config): see [CLAUDE.md](CLAUDE.md).

This project uses [Jsonnet](https://jsonnet.org/) to manage APISIX's `apisix.yaml` as modular source files. The build step merges them into a single YAML file consumed by Docker.

## How it works

```
docker/apisix/src/          ← edit these
  apisix.jsonnet            ← main entry point (imports everything)
  lib/plugins.libsonnet     ← reusable plugin helpers
  upstreams/                ← one file per upstream
  services/                 ← one file per service
  routes/                   ← one file per route

docker/apisix/dist/
  apisix.yaml               ← generated output (do not edit manually)
```

Run `./build.sh` to regenerate `dist/apisix.yaml` before starting the containers.

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

If the package is not available, use the snap build or install from source (same steps as Ubuntu above).

Verify the installation on any platform:

```bash
jsonnet --version
```

---

## Building

```bash
./build.sh
```

This generates `docker/apisix/dist/apisix.yaml` from the Jsonnet sources.

---

## Starting the stack

Always build before starting (or restarting) the containers:

```bash
./build.sh && docker compose -f docker/docker-compose.yml up -d
```

---

## Adding a new route

1. Create `docker/apisix/src/routes/my_new_route.libsonnet`:

```jsonnet
local plugins = import '../lib/plugins.libsonnet';

{
  id: 'my_new_route',
  name: 'my_new_route',
  uri: '/my/path',
  service_id: 'my_service_svc',
  plugins: plugins.limitCount(10, 60),
}
```

2. Import it in `docker/apisix/src/apisix.jsonnet`:

```jsonnet
local routes = [
  ...
  import 'routes/my_new_route.libsonnet',
];
```

3. Run `./build.sh`.

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

Then use it in any route or service file:

```jsonnet
local plugins = import '../lib/plugins.libsonnet';
plugins.myPlugin('value')
```

---

## Jenkins integration

Add a build stage before your deploy stage:

```groovy
stage('Build APISIX config') {
    steps {
        sh './build.sh'
    }
}
stage('Deploy') {
    steps {
        sh 'docker compose -f docker/docker-compose.yml up -d'
    }
}
```
