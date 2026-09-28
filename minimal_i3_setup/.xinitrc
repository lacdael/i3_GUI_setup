#!/bin/sh

userresources="$HOME/.Xresources"

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

exec dbus-run-session -- /usr/bin/i3
