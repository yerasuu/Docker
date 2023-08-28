# Use a base image with the desired development environment
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
RUN apt-get update && \
    apt-get install -y \
    sudo \
    git \
    vim \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python if version is provided
ARG PYTHON_VERSION
RUN if [ -n "$PYTHON_VERSION" ]; then \
        apt-get update && apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-distutils; \
    fi
# Create a symbolic link for python
RUN if [ -n "$PYTHON_VERSION" ]; then \
        ln -s /usr/bin/python3.10 /usr/bin/python; \
    fi

# Install Rust if version is provided
ARG RUST_VERSION
RUN if [ -n "$RUST_VERSION" ]; then \
        curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain ${RUST_VERSION} -y; \
    fi
	
# Add Rust binaries to the PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Node.js if version is provided
ARG NODE_VERSION
RUN if [ -n "$NODE_VERSION" ]; then \
        curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash - && \
        apt-get update && apt-get install -y nodejs; \
        echo 'export PATH="/usr/local/bin:${PATH}"' >> /root/.bashrc; \
    fi

# Set the working directory
WORKDIR /projects

# Start a shell in pseudo TTY mode
CMD ["/bin/bash"]

# build command docker build --build-arg Arg . -t name
# if added an arg like the above the version indicated will be installed on build
# --build-arg NODE_VERSION=14
# --build-arg PYTHON_VERSION=3.10
# --build-arg RUST_VERSION=1.72.0
# examples:
# docker build --build-arg PYTHON_VERSION=3.10 . -t jevo1900/devenv:python3.10
# docker build --build-arg PYTHON_VERSION=3.10 --build-arg NODE_VERSION=14 --build-arg RUST_VERSION=1.72.0 . -t jevo1900/devenv:full

# this container must be runned with: -t -d --name
# example:  docker run -t -d --name python jevo1900/python:3.10