#!/usr/bin/env bash

[[ $- == *i* ]] && source -- $(blesh-share)/ble.sh --attach=none

source ~/.bash_profile

[[ ! ${BLE_VERSION-} ]] || ble-attach

ble-color-setface auto_complete fg=238,underline # Set autocomplete color to greyed out and underlined
ble-face -s syntax_error fg=242                  # Set error or backspace to greyed out
