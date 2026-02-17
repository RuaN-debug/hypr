#!/usr/bin/env bash

if pgrep -x wofi > /dev/null; then
    pkill -x wofi
    exit 0
fi

DIR="$HOME/.config/hypr/wofi"
CONFIG="$DIR/config.conf"
STYLE="$DIR/style.css"
COLORS="$DIR/colors"

wofi --show drun \
     --prompt "Search..." \
     --conf "$CONFIG" \
     --style "$STYLE" \
     --color "$COLORS"
