FROM gcr.io/deeplearning-platform-release/base-cu110

RUN \
    # Install deps
    apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y apt-transport-https \
    && apt-get install -y checkinstall libreadline-dev libncursesw5-dev \
        uuid-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev openssl \
        liblzma-dev build-essential libncurses5-dev libnss3-dev libssl-dev libffi-dev wget \
    #
    # Download python source
    && wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz \
    && tar xzf Python-3.8.12.tgz \
    && cd Python-3.8.12 \
    #
    # Build and install python3.8
    && ./configure --enable-optimizations \
    && make -j 8 \
    && make altinstall \
    #
    # Install jupyter and ipython
    && apt-get install -y python3-venv \
    && python3.8 -m venv testenv \
    && . testenv/bin/activate \
    && pip install --upgrade jupyter ipython \
    #
    # Create custom 3.8 kernel
    && ipython kernel install --name "Python3.8" --user
