#!/usr/bin/env fish
# Read input using Rofi.

argparse 'P/placeholder=' 'I/icon=' 'password' 'secret' -- $argv; or exit 1

set -l rofi_args -dmenu -lines 1 -theme-str 'mainbox{children:[inputbar,message];}'

if set -q _flag_I
    set -a rofi_args -theme-str "icon{filename:\"$_flag_I\";}"
end

if set -q _flag_P
    set -a rofi_args -theme-str "entry{placeholder:\"$_flag_P\";}"
end

if set -q _flag_password; or set -q _flag_secret
    set -a rofi_args -password
end

hey.do rofi $rofi_args
