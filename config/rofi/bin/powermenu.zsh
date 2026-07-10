#!/usr/bin/env fish
# Control the system's power state.

function _rofi
    rofi -dmenu -i -theme powermenu.rasi $argv
    if test $status -gt 0
        hey.error "Nothing selected. Aborting..."
        exit 1
    end
end

function rofi_powermenu_dpms
    sleep 0.2
    if type -q hyprctl
        hey.do hyprctl dispatch dpms off
    else if type -q xset
        hey.do xset dpms force off
    else
        notify-send "Unexpected error" "No known method to sleep monitors" -i system-error
        exit 1
    end
end

function rofi_powermenu_lock; hey.do loginctl lock-session; end
function rofi_powermenu_suspend; hey.do systemctl suspend; end
function rofi_powermenu_reboot; hey.do systemctl reboot; end
function rofi_powermenu_poweroff; hey.do systemctl poweroff; end

function rofi_powermenu_reboot_into
    set -l entries (bootctl list --json=short)
    set -l lines (echo $entries | jq -r '.[] | (.id+";"+.title+";"+.version)')
    set -l rofi_input
    for line in $lines
        set -l parts (string split ';' -- $line)
        set -l id $parts[1]
        set -l title $parts[2]
        set -l version $parts[3]
        test -z "$title"; and set title $id
        test -n "$version"; and test "$version" != "null"; and set title "$title ($version)"
        set rofi_input $rofi_input "$title\0icon\x1ffolder\x1fmeta\x1f$id"
    end
    set -l i (printf "%b\n" $rofi_input | _rofi -format d)
    set -l selected_line $lines[$i]
    hey.log "Rebooting into: $selected_line"
    set -l selected_id (string replace -r ';.*' '' -- $selected_line)
    hey.do systemctl reboot --boot-loader-entry (echo $entries | jq -r --arg id "$selected_id" '.[] | select(.id == $id) | .id')
end

set -l cmds "Turn off displays;system-config-display;rofi_powermenu_dpms" \
            "Lock session;system-lock-screen;rofi_powermenu_lock" \
            "Suspend;system-suspend;rofi_powermenu_suspend" \
            "Reboot;system-reboot;rofi_powermenu_reboot" \
            "Reboot into...;system-log-out;rofi_powermenu_reboot_into" \
            "Power off;system-shutdown;rofi_powermenu_poweroff"

set -l rofi_input
for item in $cmds
    set -l parts (string split ';' -- $item)
    set rofi_input $rofi_input "$parts[1]\0icon\x1f$parts[2]"
end

set -l i (printf "%b\n" $rofi_input | _rofi -format d)
set -l selected_cmd (string split ';' -- $cmds[$i])[3]
eval $selected_cmd
