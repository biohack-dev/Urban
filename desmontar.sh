#!/bin/bash

sudo umount /mnt/urban
sudo kpartx -d ./Urban.img
echo "Urban desmontado!"
