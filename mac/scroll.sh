#!/bin/sh

#
# Sets the swipescrolldirection on a Mac to the desired direction.
#
# Passing in a value of `TRUE` will set the scroll direction to "Natural"
# and `FALSE` will set the scroll direction to "Unnatural".
#
# If a direction is not specified and the `mouse.sh` script is also installed,
# it will use that script to automagically set the appropriate direction.
#
# If a direction is not specified and the `mouse.sh` script is not installed,
# the direction will be set to "Natural".
#

val=auto

while [[ "$1" =~ ^- && ! "$1" == "--" ]]
do
  case $1 in
      -u) val="FALSE"
          dir="Unnatural"
          ;;
      -n) val="TRUE"
          dir="Natural"
          ;;
  esac
  shift
done

if [[ "$1" == "--" ]]; then shift; fi

mousecmd=$(command -v mouse.sh)

if [[ $val == auto && -n $mousecmd ]]; then
  mouse.sh
elif [[ $val =~ (TRUE|FALSE) ]]; then
  defaults write -g com.apple.swipescrolldirection -bool $val
  echo "Setting scroll direction to '$dir'"
else
  defaults write -g com.apple.swipescrolldirection -bool TRUE
  echo "Setting scroll direction to 'Natural'"
fi
