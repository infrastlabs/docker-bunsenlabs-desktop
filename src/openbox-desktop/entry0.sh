#!/bin/bash -xe

# https://github.com/murer/docker-xvfb-x11vnc-openbox/blob/master/config/docker-entrypoint.sh
# xvfb-run -s "$DISPLAY" -s '-screen 0 1024x768x24 -ac' openbox-session

# multi exec togother: cause defunct. TODO split into each xx/run?
Xvfb "$DISPLAY" -screen 0 1024x768x24 -ac &
sleep 2
openbox --startup /etc/X11/openbox/autostart &
openbox-session &
exec x11vnc -display :99 -forever -nopw