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

WORKDIR /srv/ace

# Download and install Ace Stream engine
RUN curl --progress-bar "$BASE_URL/acestream_$ACE_VERSION.tar.gz" | tar xzf - \
    && cd lib \
    && unzip -o \*.egg \
    && rm *.egg \
    && cd .. \
    && ln -s /dev/shm/.ACEStream .ACEStream \
    && ln -s /dev/shm/engine_runtime.json .

# Copy configuration
COPY setup.cfg .

# Install python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && if [ -f requirements.txt ]; then pip install --no-cache-dir --requirement requirements.txt; fi

# Expose the default Ace Stream port
EXPOSE 6878

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /dev/shm/.ACEStream /dev/shm/acecache && exec ./start-engine \"$@\"", "--"]

CMD ["--client-console",
     "--cache-dir","/dev/shm/acecache",
     "--cache-limit","1"]
