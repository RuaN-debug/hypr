#!/usr/bin/env bash
set -u

CONFIG="$HOME/.config/hypr/wofi/config.conf"
STYLE="$HOME/.config/hypr/wofi/style.css"

# Fecha qualquer wofi antigo (se não existir, segue)
pkill -x wofi 2>/dev/null || true

uptime="$(uptime -p | sed -e 's/^up //g')"

shutdown="  Shutdown"
reboot="  Restart"
lock="  Lock"
suspend="  Sleep"
logout="  Logout"

wofi_menu() {
  wofi --show dmenu \
    --prompt "$1" \
    --conf "$CONFIG" --style "$STYLE" \
    --width 320 --height 260 \
    --cache-file /dev/null \
    --hide-scroll --no-actions \
    --define matching=fuzzy
}

confirm() {
  # retorna 0 se "Yes"
  choice="$(printf "No\nYes\n" | wofi_menu "Confirm?")"
  [[ "$choice" == "Yes" ]]
}

chosen="$(printf "%s\n%s\n%s\n%s\n%s\n" \
  "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | wofi_menu "UP - $uptime")"

# Se o usuário apertou ESC/fechou
[[ -z "${chosen:-}" ]] && exit 0

case "$chosen" in
  "$shutdown")
    confirm && systemctl poweroff
    ;;
  "$reboot")
    confirm && systemctl reboot
    ;;
  "$lock")
    "$HOME/.config/hypr/.scripts/lockscreen.sh"
    ;;
  "$suspend")
    if confirm; then
      command -v mpc >/dev/null 2>&1 && mpc -q pause || true
      command -v pulsemixer >/dev/null 2>&1 && pulsemixer --mute || true
      "$HOME/.config/hypr/.scripts/lockscreen.sh"
      systemctl suspend
    fi
    ;;
  "$logout")
    confirm && hyprctl dispatch exit 0
    ;;
esac
