#!/usr/bin/env bash

[[ $- == *i* ]] && source -- $(blesh-share)/ble.sh --attach=none

source ~/.bash_profile

[[ ! ${BLE_VERSION-} ]] || ble-attach
