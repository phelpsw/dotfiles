#!/bin/sh -e

# Take a screenshot
scrot -z /tmp/screen_locked.png

# Pixellate it 10x
#mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png

# Turn the screen off after a delay.
sleep 900; pgrep i3lock && xset dpms force off
