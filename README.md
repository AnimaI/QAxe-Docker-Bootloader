# QAxe-Docker-Bootloader
Docker-Bootloader for Qaxe Repository [github.com/shufps/qaxe](https://github.com/shufps/qaxe)

## Description:
This project provides an automated build system in a Docker environment for the [github.com/shufps/qaxe](https://github.com/shufps/qaxe).

It builds the firmware for the QAxe and QAxe+ devices with the STM32L072CB chip in a Docker environment and prepares them for flashing. The flashing process is done via the USB bootloader on the device, which is activated by pressing the BOOT button.

## Features:
- **Automatic Cloning of the QAxe Repository**: The build system automatically clones the QAxe repository, including all necessary submodules.
- **Build Process in a Docker Container**: All required dependencies and tools are executed within a Docker container to ensure a uniform and reproducible build environment.
- **Creation of the qaxe.bin File**: The firmware for QAxe and QAxe+ is automatically compiled and saved as `qaxe.bin`, ready for flashing onto the STM32L072CB chip.
- **Flash Support**: After the build process, the `qaxe.bin` file can be flashed onto the QAxe and QAxe+ devices via the USB bootloader.

## Usage:
The `build.sh` script has been successfully tested in a Debian 12 environment.

To use the build system, Docker must be installed on the host. For Docker installation, please refer to the official documentation.

The script can be executed as follows:

```bash
./build.sh
```

The build process generates a `qaxe.bin` file, which can then be flashed via USB onto QAxe and QAxe+ devices by pressing the BOOT button on the device. For more information on handling the BOOT button (QAxe, QAxe+), visit [github.com/shufps/qaxe](https://github.com/shufps/qaxe).

After creating the `qaxe.bin` file, the flashing in the Docker environment can be done with the following commands:

```bash
dfu-util --list
dfu-util -a 0 -s 0x08000000:leave -D qaxe.bin
```

## 📜 License
This project is **open-source** and released under the **GPLv3 License**. Feel free to modify and share!
