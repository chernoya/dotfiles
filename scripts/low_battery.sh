#!/bin/sh

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

WARNING_LEVEL=20
BATTERY_DISCHARGING=`acpi -b | grep "Battery 0" | grep -c "Discharging"`
BATTERY_LEVEL=`acpi -b | grep "Battery 0" | grep -P -o '[0-9]+(?=%)'`

EMPTY_FILE=/tmp/batteryempty
FULL_FILE=/tmp/batteryfull

# reset notif
if [ $BATTERY_DISCHARGING -eq 1 ] && [ -f $FULL_FILE ]; then
    rm $FULL_FILE
elif [ $BATTERY_DISCHARGING -eq 0 ] && [ -f $EMPTY_FILE ]; then
    rm $EMPTY_FILE
fi


if [ $BATTERY_LEVEL -gt 95 ] && [ $BATTERY_DISCHARGING -eq 0 ] && [ ! -f $FULL_FILE ]; then
    notify-send -i ~/.config/dunst/high.png "battery juiced up" "disconnect the bitch" -u low -r 9991 
    touch $FULL_FILE

elif [ $BATTERY_LEVEL -le $WARNING_LEVEL ] && [ $BATTERY_DISCHARGING -eq 1 ] && [ ! -f $EMPTY_FILE ]; then
    notify-send -i ~/.config/dunst/low.png "battery low cuh (${BATTERY_LEVEL}%)" "get the fuckin charger" -u critical -r 9991
    touch $EMPTY_FILE
fi
