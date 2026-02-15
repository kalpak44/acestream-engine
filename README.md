# Ace Stream Engine Docker Image

This repository contains a modernized Docker image for the [Ace Stream](https://acestream.org/) engine. Ace Stream is a multimedia platform based on P2P (Peer-to-Peer) technology, primarily used for high-quality video streaming.

## Features

- **Lightweight:** Based on `python:3.10-slim`.
- **Optimized:** Uses official `python:3.10-slim` image and `uv` for fast dependency installation.
- **Health check:** Includes a simple mechanism to monitor the engine's status.
- **Automated Builds:** Images are automatically built and published to GitHub Container Registry (GHCR).

## How to run it

You can run the Ace Stream engine as a standalone service using Docker:

```bash
docker run --detach \
  --name acestream-engine \
  --publish 6878:6878 \
  ghcr.io/kalpak44/acestream-engine:latest
```

After starting the container, the Ace Stream engine will be accessible on its standard port `6878`.

### Usage Examples

You can access Ace Stream broadcasts by pointing your favorite media player (VLC, IINA, etc.) to the following URLs, depending on the desired streaming protocol:

**For HLS:**
```text
http://127.0.0.1:6878/ace/manifest.m3u8?id=dd1e67078381739d14beca697356ab76d49d1a2
```

**For MPEG-TS:**
```text
http://127.0.0.1:6878/ace/getstream?id=dd1e67078381739d14beca697356ab76d49d1a2
```

*Replace `dd1e67078381739d14beca697356ab76d49d1a2` with the actual ID of the Ace Stream channel.*

### Passing arguments

You can pass additional arguments to the Ace Stream engine by adding them at the end of the `docker run` command:

```bash
docker run --detach \
  --name acestream-engine \
  --publish 6878:6878 \
  ghcr.io/kalpak44/acestream-engine:latest \
  --cache-dir /dev/shm/acecache --cache-max-bytes 1610612736
```

By default, the engine runs with the following settings:
- `--client-console` (always included via entrypoint)
- `--cache-dir /dev/shm/acecache`
- `--cache-max-bytes 1610612736`
- `--cache-auto 0`
- `--live-cache-type memory`

The entrypoint also automatically creates `/dev/shm/.ACEStream` and `/dev/shm/acecache` directories at runtime.

### Using with Docker Compose

```yaml
services:
  acestream:
    image: ghcr.io/kalpak44/acestream-engine:latest
    container_name: acestream-engine
    ports:
      - "6878:6878"
    restart: always
```

## Tags

- `latest`: The most recent stable build from the `main` branch.
- `[short-sha]`: Specific builds identified by their Git short SHA.

## Usage as a Base Image

This image is designed to be easily used as a base for other services. 
Example: [acestream-service](https://github.com/vstavrinov/acestream-service)
