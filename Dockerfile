FROM python:3.10-slim-bookworm

LABEL \
    maintainer="Pavel Usanli <pavel.usanli@gmail.com>" \
    org.opencontainers.image.title="acestream-engine" \
    org.opencontainers.image.description="AceStream engine" \
    org.opencontainers.image.url="https://github.com/kalpak44/acestream-engine" \
    org.opencontainers.image.vendor="https://pavel-usanli.online/"

ENV VERSION="3.2.11_ubuntu_22.04_x86_64_py3.10"

WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        bash \
        ca-certificates \
        catatonit \
        curl \
        libgirepository1.0-dev

RUN mkdir -p /app /.cache && \
    curl -fsSL "https://download.acestream.media/linux/acestream_${VERSION}.tar.gz" \
        | tar xzf - -C /app

COPY . /

RUN pip install uv && \
    uv pip install --system --requirement /app/requirements.txt && \
    pip uninstall --yes uv

RUN chmod -R 755 /app && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

EXPOSE 6878/tcp

CMD ["--cache-dir", "/dev/shm/acecache", "--cache-max-bytes", "1610612736", "--cache-auto", "0", "--live-cache-type", "memory"]