#!/bin/bash
set -e

# Define variables
IMAGE_NAME="qaxe-builder"
OUTPUT_DIR="/opt/qaxe-docker/output"

# Color definitions
#GREEN='\033[0;32m'
GREEN='\033[1;92m'
#RED-fett='\033[1;31m'
RED='\033[1;91m'
NC='\033[0m' # No Color

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}=>  => This script must be run as root. Please use 'sudo ./build.sh' or run as root.${NC}"
  exit 1
fi

echo -e "${GREEN}=>  => sudo check ... OK${NC}"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Set permissions (optional, depending on requirements)
chmod 777 "$OUTPUT_DIR"

# Docker-Image bauen
echo -e "${GREEN}=>  => Building the Docker image '$IMAGE_NAME'...${NC}"
docker build --no-cache -t "$IMAGE_NAME" .

# Docker-Container starten und qaxe.bin bauen
echo -e "${GREEN}=>  => Starting the Docker container and building the qaxe.bin...${NC}"
docker run --rm -it --privileged \
    -v "$OUTPUT_DIR":/output \
    "$IMAGE_NAME" \
    bash -c "\
        # Navigate to the workspace directory
        cd /workspace && \
        
        # Remove any existing qaxe directory
        rm -rf qaxe && \
        
        # Clone the qaxe repository
        git clone https://github.com/shufps/qaxe.git && \
        cd qaxe && \
        
        # Initialize and update submodules
        git submodule init && \
        git submodule update && \
        
        # Add the necessary Rust targets
        rustup target add thumbv6m-none-eabi && \
        #rustup target add thumbv7m-none-eabi && \
        
        # Navigate to the firmware directory
        cd firmware/fw-L072CB && \
        
        # Make the build script executable and run it
        chmod +x build.sh && \
        ./build.sh && \
        
        # Create the qaxe.bin file and place it in the /output directory
        DEFMT_LOG=info cargo objcopy --release --bin qaxe -- -O binary /output/qaxe.bin && \
        
        # Check the created binary file
        ls -l /output/qaxe.bin && \
        
        # Instruction
        echo -e \"${GREEN}\" && \
        echo -e \"---------------------------------------------------------\" && \
        echo -e \"Build completed.\" && \
        echo -e \"Please put the STM32 into DFU mode by pressing 'boot' (only for STM32L072CB).\" && \
        echo -e \"Then execute the following commands:\" && \
        echo -e \"\" && \
        echo -e \"dfu-util --list\" && \
        echo -e \"dfu-util -a 0 -s 0x08000000:leave -D qaxe.bin\" && \
        echo -e \"---------------------------------------------------------\" && \
        echo -e \"${NC}\" && \
        
        # Switch to /output and start an interactive Bash session
        cd /output && \
        exec bash"

