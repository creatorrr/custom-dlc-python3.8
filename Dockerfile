FROM gcr.io/deeplearning-platform-release/base-cu110

ENV PATH=/opt/conda/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.local/bin
ENV ANACONDA_PYTHON_VERSION=3.8

# Install deps
RUN \
    apt-get update -yqq \
    && apt-get upgrade -yq \
    && apt-get install -y --no-install-recommends apt-transport-https \
    && apt-get install -y --no-install-recommends checkinstall libreadline-dev libncursesw5-dev \
        uuid-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev openssl \
        liblzma-dev build-essential libncurses5-dev libnss3-dev libssl-dev libffi-dev wget \
    && rm -rf /var/lib/apt/lists/*

# Download python source
RUN \
    cd $HOME \
    && wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz \
    && tar xzf Python-3.8.12.tgz

# Build and install python3.8
RUN \
    cd $HOME/Python-3.8.12 \
    && ./configure --enable-optimizations \
    && make -j 8 \
    && make altinstall \
    && cd $HOME \
    && rm -rf Python-3.8.*

# Install jupyter and ipython
RUN \
    python3.8 -m venv $HOME/.py38env \
    && $HOME/.py38env/bin/pip install --no-cache-dir --upgrade jupyter ipython

# Create custom 3.8 kernel
RUN \
    ipython kernel install --name "Python3.8" --prefix $HOME/.py38env \
    && . $HOME/.py38env/bin/activate \
    && ipython kernel install --name "Python3.8-user" --user

# Clean up apt
RUN \
    apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Clean up conda/pip
RUN \
    conda clean -a -q \
    && pip cache purge

# Remove man and locale files
RUN \
    rm -rf /usr/share/doc /usr/share/man /usr/share/locale
