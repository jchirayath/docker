# docker

Personal collection of Docker helper scripts and Compose files, centered on
running an **Apache Kafka stack** (Kafka broker + Kafka Manager + ZooKeeper) in
containers.

> Archival / personal tooling — last actively used around 2019, from before
> managed Kafka made this unnecessary. Kept as a record; see
> [Before running this](#before-running-this) for why it will not work unchanged.

## What's here

### Own scripts

| Path | Purpose |
|------|---------|
| `docker_common.sh` | Shared bash helpers sourced by the other scripts (build/run/cleanup utilities). |
| `build-run-container.sh` | Build and run a container from a local Dockerfile. |
| `build-zookeeper.sh` | Build/run a ZooKeeper container. |
| `kafka.sh` | Start/stop wrapper for the broker container. |
| `zookeeper.sh` | Start/stop wrapper for the ZooKeeper container. |
| `kafka-manager.sh` | Build the [Kafka Manager / CMAK](https://github.com/yahoo/CMAK) UI image and run it. |
| `edp_all.sh` | Bring up the full stack end-to-end. |
| `docker-compose.yml` | Top-level Compose definition. |
| `kafka-manager/` | Dockerfile + entrypoint for the Kafka Manager image. |
| `zookeeper/conf/zoo.cfg` | ZooKeeper config used by the mounted container. |

### Vendored upstream

Copied in rather than referenced, so a build never depended on someone else's
registry or branch staying put. Each keeps its own licence — see
[Licence](#licence).

| Path | Upstream |
|------|----------|
| `kafka-docker/` | [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker) — broker image and its test harness. |
| `kafka-manager-docker/` | Compose + Dockerfile for the Kafka Manager image. |
| `zookeeper-docker/` | ZooKeeper image build. |

## Usage

```bash
# Source the shared helpers, then bring the stack up
source docker_common.sh
./edp_all.sh                 # build + run the full Kafka stack
./kafka-manager.sh           # start the Kafka Manager UI
```

Most scripts assume Docker (and `docker-compose`) are installed and that you run
them from the repo root.

## Before running this

Read each script first. These were written for one machine and never generalised:

- **A hard-coded IP.** `kafka.sh` and `zookeeper.sh` set `MY_IP=10.23.53.85`, and
  derive a host number from the last digit of the hostname.
- **Hard-coded absolute paths.** `zookeeper/conf/zoo.cfg` points its data, log and
  conf directories at `/home/jchirayath/docker/zookeeper/...`.
- **Image tags are inconsistent.** Some are era-pinned (`wurstmeister/kafka:0.9.0.0-1`),
  others float (`wurstmeister/kafka:latest`, `sheepkiller/kafka-manager:latest`) or
  carry no tag at all. Nothing here reproduces reliably today; pin every tag before
  trusting a build.
- **Kafka has moved on.** ZooKeeper is no longer how Kafka stores metadata (KRaft
  replaced it), so this topology is historical rather than a starting point.

## Licence

The scripts in this repository's own root and `kafka-manager/` are MIT — see
[LICENSE](LICENSE).

The vendored directories `kafka-docker/`, `kafka-manager-docker/` and
`zookeeper-docker/` are third-party code under the **Apache License 2.0**, and
each retains its own licence file. The MIT grant does not cover them.
