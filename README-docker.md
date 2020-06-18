# Docker Container

This repository comes with built-in Dockerfile to support docker
containers. This README serves as documentation.

## Dockerfile Specifications

The `Dockerfile` performs the following steps:

1. Obtain base image (phusion/baseimage:0.10.1)
2. Install required dependencies using `apt-get`
3. Add deex-core source code into container
4. Update git submodules
5. Perform `cmake` with build type `Release`
6. Run `make` and `make_install` (this will install binaries into `/usr/local/bin`
7. Purge source code off the container
8. Add a local deex user and set `$HOME` to `/var/lib/deex`
9. Make `/var/lib/deex` and `/etc/deex` a docker *volume*
10. Expose ports `8090` and `1776`
11. Add default config from `docker/default_config.ini` and entry point script
12. Run entry point script by default

The entry point simplifies the use of parameters for the `witness_node`
(which is run by default when spinning up the container).

### Supported Environmental Variables

* `$DEEXD_SEED_NODES`
* `$DEEXD_RPC_ENDPOINT`
* `$DEEXD_PLUGINS`
* `$DEEXD_REPLAY`
* `$DEEXD_RESYNC`
* `$DEEXD_P2P_ENDPOINT`
* `$DEEXD_WITNESS_ID`
* `$DEEXD_PRIVATE_KEY`
* `$DEEXD_TRACK_ACCOUNTS`
* `$DEEXD_PARTIAL_OPERATIONS`
* `$DEEXD_MAX_OPS_PER_ACCOUNT`
* `$DEEXD_ES_NODE_URL`
* `$DEEXD_TRUSTED_NODE`

### Default config

The default configuration is:

    p2p-endpoint = 0.0.0.0:9090
    rpc-endpoint = 0.0.0.0:8090
    bucket-size = [60,300,900,1800,3600,14400,86400]
    history-per-size = 1000
    max-ops-per-account = 1000
    partial-operations = true

# Docker Compose

With docker compose, multiple nodes can be managed with a single
`docker-compose.yaml` file:

    version: '3'
    services:
     main:
      # Image to run
      image: deex/deex-core:latest
      # 
      volumes:
       - ./docker/conf/:/etc/deex/
      # Optional parameters
      environment:
       - DEEXD_ARGS=--help


    version: '3'
    services:
     fullnode:
      # Image to run
      image: deex/deex-core:latest
      environment:
      # Optional parameters
      environment:
       - DEEXD_ARGS=--help
      ports:
       - "0.0.0.0:8090:8090"
      volumes:
      - "deex-fullnode:/var/lib/deex"


# Docker Hub

This container is properly registered with docker hub under the name:

* [deex/deex-core](https://hub.docker.com/r/deex/deex-core/)

Going forward, every release tag as well as all pushes to `develop` and
`testnet` will be built into ready-to-run containers, there.

# Docker Compose

One can use docker compose to setup a trusted full node together with a
delayed node like this:

```
version: '3'
services:

 fullnode:
  image: deex/deex-core:latest
  ports:
   - "0.0.0.0:8090:8090"
  volumes:
  - "deex-fullnode:/var/lib/deex"

 delayed_node:
  image: deex/deex-core:latest
  environment:
   - 'DEEXD_PLUGINS=delayed_node witness'
   - 'DEEXD_TRUSTED_NODE=ws://fullnode:8090'
  ports:
   - "0.0.0.0:8091:8090"
  volumes:
  - "deex-delayed_node:/var/lib/deex"
  links: 
  - fullnode

volumes:
 deex-fullnode:
```
