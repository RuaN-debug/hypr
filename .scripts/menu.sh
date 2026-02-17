#!/usr/bin/env bash

DIR="$HOME/.config/hypr/wofi"
CONFIG="$DIR/config.conf"
STYLE="$DIR/style.css"
COLORS="$DIR/colors"

wofi --show drun \
     --prompt "Search..." \
     --conf "$CONFIG" \
     --style "$STYLE" \
     --color "$COLORS"
