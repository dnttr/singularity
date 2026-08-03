# Quick Setup Guide

## Requirements

Ensure you have the following:

* **[Homebrew](https://brew.sh)**

---

## Installation

### 1. Essentials

If you already have Homebrew installed, run the following command in your terminal:

```bash
brew install lima
```

### 2. Instance

Start a default Ubuntu instance with standard mounts:

```bash
limactl start --name=singularity template://ubuntu
```

> **Note:**
> When prompted by `limactl`, select **Proceed with default configuration**. The process
> may take a few minutes to complete.

### 3. Configuration

Now that the instance creation is done and the instance is running, we need to configure it to allow IO operations and
GPU access. The first step is to stop the instance:

```bash
limactl stop singularity
```

Then, edit the instance configuration file:

```bash
limactl edit singularity
```

> **Note:** A ready configuration file is provided in the `lima` folder of this repository.

There are two important changes to make in the configuration file:

```
mounts:
- location: "~"
  writable: true  #  <-- This should be set to true
```

along with:

```
video:
  display: "default"
```

> **Note:** Keep in mind, that if using Lima's vz (macOS native hypervisor), you should make sure that GPU acceleration
> is enabled.

Once that is complete, start the instance again:

```bash
limactl start singularity
```

### 4. Dependencies

In order to access the instance, run:

```bash
limactl shell singularity
```

Once inside the instance, install the required dependencies:

```bash
sudo apt update && sudo apt install -y \
    build-essential \
    pkg-config \
    libdrm-dev \
    libgbm-dev \
    libinput-dev \
    libudev-dev \
    libxkbcommon-dev \
    libseat-dev \
    curl git
```

Make sure, to also install Rust toolchain:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

### 5. Permissions

In order to ensure smooth code execution, i.e. read access to system event paths and kernel DRM interfaces, run the
following command:

```bash
sudo usermod -aG render,video,input $USER
```

To apply the changes:

```bash
exit
```