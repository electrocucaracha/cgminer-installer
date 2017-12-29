#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2017
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# We need to execute everything as root
if [[ $(whoami) != "root" ]]; then
    echo "Error: This script must be run as root!"
    exit 1
fi

source /etc/os-release || source /usr/lib/os-release
case ${ID,,} in
    *suse)
    ;;
    ubuntu|debian)
        apt-get update && apt-get upgrade -y
        apt-get install -y git pkg-config libtool            # Mandatory dependencies
        apt-get install -y libcurl4-openssl-dev              # cURL Development library
        apt-get install -y libncurses5-dev                   # Curses Development library
        apt-get install -y libudev-dev libusb-1.0-0-dev      # USB Device support
        apt-get install -y build-essential autoconf automake # Building from GIT
    ;;
    rhel|centos|fedora)
    ;;
    esac

mkdir -p /usr/src/cgminer
git clone https://github.com/ckolivas/cgminer.git /usr/src/cgminer
pushd /usr/src/cgminer
./autogen.sh
CFLAGS="-O2 -Wall -march=native" ./configure ${CGMINER_SUPPORT:"--enable-icarus"}
make
