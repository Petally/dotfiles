#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log
if type "xrandr"; then
	for entry in $(xrandr --query | grep " connected"); do
		mon=$(cut -d" " -f1 <<<"$entry")
		status=$(cut -d" " -f3 <<<"$entry")

		tray_pos="right"
		#if [ "$status" == "primary" ]; then
		#	tray_pos="right"
		#fi

		MONITOR=$mon TRAY_POS=$tray_pos polybar -r bar 2>&1 | tee -a /tmp/polybar-monitor-"$mon".log &
		disown
	done
else
	polybar --reload bar &
fi
echo "Bars launched..."
