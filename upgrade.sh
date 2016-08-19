#!/bin/bash

CLEANUP=$1
PACKAGES_TO_UPGRADE="${@:2}"
PACKAGE_COUNT=$(( $# - 1 ))
BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)
BEER_ICON=$HOME/.homebrew-notifier/beer-icon.png
BREW_UPDATE_LOG=/tmp/homebrew-notifier-update.log

$TERMINAL_NOTIFIER -sender com.apple.Terminal \
    -appIcon $BEER_ICON \
    -title "Homebrew Updating..." \
    -subtitle "Update in progress" \
    -message "Updating $PACKAGE_COUNT formulae..." \

$BREW upgrade "$PACKAGES_TO_UPDATE" > $BREW_UPDATE_LOG

if $CLEANUP; then
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon $BEER_ICON \
        -title "Homebrew Cleaning..." \
        -subtitle "Cleanup in progress" \
        -message "Removing old versions, downloads, and caches." \

    $BREW cleanup
fi

if [ $? -eq 0 ]; then
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon $BEER_ICON \
        -title "Homebrew Updates Complete" \
        -subtitle "Successfully updated the following formulae:" \
        -message "$PACKAGES_TO_UPDATE" \
        -sound default
else
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon $BEER_ICON \
        -title "Homebrew Updates Failed" \
        -subtitle "Failed to update some or all of the following formulae:" \
        -message "$PACKAGES_TO_UPDATE" \
        -sound default \
        -open $BREW_UPDATE_LOG
fi
