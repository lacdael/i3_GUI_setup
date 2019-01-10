#!/bin/sh

userresources=/home/christian/.Xresources

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

/usr/bin/i3
