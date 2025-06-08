#!/usr/bin/env bash

DEVICE="/dev/sda1"

if [ -b "$DEVICE" ]; then
    udisksctl mount -b "$DEVICE"
else
    echo "$DEVICE is not connected."
fi
