#!/bin/dash

currentSpaceLayout=$(yabai -m query --spaces --space | jq -r ".type")
echo "$currentSpaceLayout"

if [ "$currentSpaceLayout" = "stack" ]; then
    $(yabai -m space --layout bsp)
else
    $(yabai -m space --layout stack)
fi
