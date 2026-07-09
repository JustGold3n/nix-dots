#!/bin/sh
mon=$(niri msg -j focused-output 2>/dev/null | jq -r '.name // empty')
qs -c pill ipc call pill "$1" "$mon"
