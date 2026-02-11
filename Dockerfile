FROM python:3.10-slim

# Set environment variables
ENV BASE_URL="https://download.acestream.media/linux" \
    ACE_VERSION="3.2.11_ubuntu_22.04_x86_64_py3.10" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TMPDIR=/dev/shm

# Set shell for pipefail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create non-privileged user and set permissions
RUN useradd --shell /bin/bash --home-dir /srv/ace --create-home ace
WORKDIR /srv/ace

# Download and install Ace Stream engine
RUN curl --progress-bar "$BASE_URL/acestream_$ACE_VERSION.tar.gz" | tar xzf - \
    && cd lib \
    && unzip -o \*.egg \
    && rm *.egg \
    && cd .. \
    && ln -s /dev/shm/.ACEStream .ACEStream \
    && ln -s /dev/shm/engine_runtime.json .

# Copy configuration and set ownership
COPY setup.cfg .
RUN chown -R ace:ace /srv/ace

USER ace
ENV PATH="/srv/ace/.local/bin:${PATH}"

# Install python dependencies
RUN pip install --no-cache-dir --user --upgrade pip \
    && if [ -f requirements.txt ]; then pip install --no-cache-dir --user --requirement requirements.txt; fi

# Expose the default Ace Stream port
EXPOSE 6878

# Ensure runtime directory exists and start the engine
ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /dev/shm/.ACEStream && ./start-engine \"$@\"", "--"]
CMD ["--client-console", "--live-cache-type", "memory"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:6878 || exit 1
