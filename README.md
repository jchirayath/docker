# docker

Personal collection of Docker helper scripts and Compose files, centered on
running an **Apache Kafka stack** (Kafka broker + Kafka Manager + ZooKeeper) in
containers.

> Archival / personal tooling — last actively used around 2019. Versions are
> pinned to that era (e.g. legacy Kafka images).

## What's here

| Path | Purpose |
|------|---------|
| `docker_common.sh` | Shared bash helpers sourced by the other scripts (build/run/cleanup utilities). |
| `build-run-container.sh` | Build and run a container from a local Dockerfile. |
| `build-zookeeper.sh` | Build/run a ZooKeeper container. |
| `kafka-manager.sh`, `kafka-manager/` | Build the [Kafka Manager](https://github.com/yahoo/CMAK) UI image and run it. |
| `kafka-manager-docker/` | Compose + Dockerfile for the Kafka Manager image. |
| `kafka-docker/` | Vendored copy of [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker) (broker image + test harness). |
| `edp_all.sh` | Bring up the full stack end-to-end. |
| `docker-compose.yml` | Top-level Compose definition. |

## Usage

```bash
# Source the shared helpers, then bring the stack up
source docker_common.sh
./edp_all.sh                 # build + run the full Kafka stack
./kafka-manager.sh           # start the Kafka Manager UI
```

Most scripts assume Docker (and `docker-compose`) are installed and that you
run them from the repo root. Review each script before running — image tags and
hostnames are hard-coded for the original environment.
