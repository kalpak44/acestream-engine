FROM python:3.10-slim-bookworm

LABEL \
  maintainer="Pavel Usanli <pavel.usanli@gmail.com>" \
  org.opencontainers.image.title="acestream-engine" \
  org.opencontainers.image.description="AceStream engine" \
  org.opencontainers.image.url="https://github.com/kalpak44/acestream-engine" \
  org.opencontainers.image.vendor="https://pavel-usanli.online/"

ENV VERSION="3.2.11_ubuntu_22.04_x86_64_py3.10"
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y \
    bash ca-certificates catatonit curl libgirepository1.0-dev \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app /.cache \
  && curl -fsSL "https://download.acestream.media/linux/acestream_${VERSION}.tar.gz" | tar xzf - -C /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
EXPOSE 6878/tcp

# memory-only cache, max 2 GiB
CMD ["--live-cache-type","memory","--cache-max-bytes","2147483648","--cache-auto","0"]
