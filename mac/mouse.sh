#!/bin/sh

# Automatically set teh scroll direction base on the presence of an attached mouse.
# If a mouste is attached, the scroll direction is set to "Unnatural", otherwise the
# direction is set to "Natural"

dir="Natural"
val="TRUE"
mouse=0

mouse=$(system_profiler SPUSBDataType 2>/dev/null | awk '$0  /USB.Optical.Mouse/ { print "1" }')

if [[ $mouse -eq 1 ]]; then
  val="FALSE"
  dir="Unnatural"
fi

defaults write -g com.apple.swipescrolldirection -bool $val
echo "Setting scroll direction to '$dir'"
