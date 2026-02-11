# Ace Stream Engine Docker Image

This repository contains a modernized Docker image for the [Ace Stream](https://acestream.org/) engine. Ace Stream is a multimedia platform based on P2P (Peer-to-Peer) technology, primarily used for high-quality video streaming.

## Features

- **Lightweight:** Based on `python:3.10-slim`.
- **Security:** Runs as a non-privileged user (`ace`).
- **Optimized:** Uses `/dev/shm` for temporary storage and engine runtime to improve performance and reduce disk I/O.
- **Healthcheck:** Includes a built-in healthcheck to monitor the engine's status.
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
