# Base image
FROM debian:bullseye

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUSTUP_HOME=/root/.rustup
ENV CARGO_HOME=/root/.cargo

# Install system packages and necessary build dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    llvm-11 \
    pkg-config \
    libusb-1.0-0-dev \
    usbutils \
    ca-certificates \
    autoconf \
    automake \
    libtool \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y

# Install cargo-binutils and llvm-tools
RUN /root/.cargo/bin/cargo install cargo-binutils && \
    /root/.cargo/bin/rustup component add llvm-tools-preview

# Create symlink for llvm-objcopy
RUN ln -s /usr/bin/llvm-objcopy-11 /usr/bin/llvm-objcopy

# Install dfu-util by cloning and building the Git repository
RUN git clone https://git.code.sf.net/p/dfu-util/dfu-util.git /tmp/dfu-util && \
    cd /tmp/dfu-util && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    rm -rf /tmp/dfu-util

# Create working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
