#!/bin/bash

sudo debootstrap --arch amd64 --include=systemd-sysv,linux-image-amd64 bookworm /mnt/urban https://deb.debian.org/debian/
