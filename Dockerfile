FROM python:3.10-slim-bookworm

LABEL \
    maintainer="Pavel Usanli <pavel.usanli@gmail.com>" \
    org.opencontainers.image.title="acestream-engine" \
    org.opencontainers.image.description="AceStream engine" \
    org.opencontainers.image.url="https://github.com/kalpak44/acestream-engine" \
    org.opencontainers.image.vendor="https://pavel-usanli.online/"

ENV DEBIAN_FRONTEND="noninteractive" \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHON_EGG_CACHE=/.cache

# IMPORTANT: use the py3.8 build
ENV VERSION="3.2.11_ubuntu_22.04_x86_64_py3.8"

WORKDIR /app

RUN \
    apt-get update \
    && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        bash \
        ca-certificates \
        catatonit \
        curl \
        libgirepository1.0-dev \
    && mkdir -p /app \
    && mkdir -p /.cache \
    && curl -fsSL "https://download.acestream.media/linux/acestream_${VERSION}.tar.gz" \
        | tar xzf - -C /app \
    && pip install uv \
    && uv pip install --requirement /app/requirements.txt \
    && chown -R appuser:appuser /.cache /app && chmod -R 755 /app \
    && pip uninstall --yes uv \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

COPY . /

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

EXPOSE 6878/tcp

CMD ["--cache-dir", "/dev/shm/acecache", "--cache-max-bytes", "1610612736", "--cache-auto", "0", "--live-cache-type", "memory"]