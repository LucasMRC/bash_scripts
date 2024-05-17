#!/bin/bash
# Send a notification if the laptop battery is either low

# This functionality is using the 'acpi' package to get the battery status.
# The script is checking the battery status every 5 minutes using a cron job.
# The cron job package that I'm using now is 'cronie'
# 'crontab -e' to edit the cron jobs, and '*/5 * * * *' to check every 5 minutes.

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Battery percentage at which to notify
WARNING_LEVEL=10
# Check which is the main battery.
BATTERY_DISCHARGING=$(acpi -b | grep -v "rate information unavailable" | grep -c "Discharging")
BATTERY_LEVEL=$(acpi -b | grep -v "rate information unavailable" | grep -P -o '[0-9]+(?=%)')

# Use two files to store whether we've shown a notification or not (to prevent multiple notifications)
EMPTY_FILE=/tmp/batteryempty

# Reset notifications if the computer is charging/discharging
if [ "$BATTERY_DISCHARGING" -gt 0 ] && [ -f $EMPTY_FILE ]; then
    rm $EMPTY_FILE
fi

# If the battery is discharging and below the warning level (and has not shown notification yet)
if [ "$BATTERY_LEVEL" -le $WARNING_LEVEL ] && [ "$BATTERY_DISCHARGING" -gt 0 ] && [ ! -f $EMPTY_FILE ]; then
    notify-send "Low Battery" "${BATTERY_LEVEL}% of battery remaining." -u critical -i "$HOME/.config/scripts/battery-alert.svg" -r 9991
    touch $EMPTY_FILE
fi
