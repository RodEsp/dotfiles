#!/usr/bin/env bash

kill $(pgrep waybar)
hyprctl dispatch exec waybar

