#!/usr/bin/env bash

# on AC or not
# first check on_ac_power from upower
if command -v on_ac_power >/dev/null 2>&1; then
    if on_ac_power; then
        # on_ac_power, do nothing
        exit 0
    fi
else
    # Linux sysfs
    # AC starts with A (AC, ADP1, ACAD)
    ac_status=$(cat /sys/class/power_supply/A*/online 2>/dev/null | head -n 1)
    if [ "$ac_status" = "1" ]; then
        # on ac power, do nothing
        exit 0
    fi
fi

systemctl suspend

#cat /sys/class/power_supply/AC/online            # AC: 1=on, 0=off
#cat /sys/class/power_supply/ADP0/online          # some models

#cat /sys/class/power_supply/BAT0/status          # Charging/Discharging/Full

################################
## on_ac_power alternate
#
#for ac in /sys/class/power_supply/AC*/online \
#          /sys/class/power_supply/ADP*/online \
#          /sys/class/power_supply/*/type; do
#    if [ -f "$ac" ]; then
#        if grep -q "Mains" "$ac" 2>/dev/null || [[ "$ac" == *"/online" ]]; then
#            dir=$(dirname "$ac")
#            if [ -f "$dir/online" ]; then
#                read val < "$dir/online"
#                [ "$val" = "1" ] && exit 0   # AC
#                [ "$val" = "0" ] && exit 1   # not on ac
#            fi
#        fi
#    fi
#done
#
## not on ac
#exit 0
################################
