#!/bin/sh

# Creates a spacer in the dock

defaults write com.apple.dock persistent-apps -array-add '{"title-type"="spacer-tile";}'; killall Dock
