#!/bin/sh

#
# This script enables or disables the wi-fi airport on a mac laptop based on whether or not there is an
# active ethernet connection detected.
#

# Determine whether there is an active Hardwired connection
function is_lan_active() {
  act=0
  if [[ -n $1 ]]; then
    while read line; do
      if [[ "$line" =~ active && ! "$line" =~ inactive ]]; then
        act=1
      fi
    done <<< "$(ifconfig $1 2>/dev/null)"
  fi
}

wifi=$(networksetup -listnetworkserviceorder | grep 'Wi-Fi, Device' | sed -E "s/.*(en[0-9]).*/\1/")
lan=$(networksetup -listnetworkserviceorder | grep '(Ethernet|LAN), Device' | sed -E "s/.*(en[0-9]).*/\1/")
lanactive="$(is_lan_active $lan)"
pwr="on"
msg="No wired network detected."

if [[ $lanactive -eq 1 ]]; then
  pwr="off"
  msg="Wired network detected."
fi

newtorksetup -setairportpower $wifi $pwr
echo "$msg"
