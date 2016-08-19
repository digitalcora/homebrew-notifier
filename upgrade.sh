#!/bin/bash

CLEANUP=$1
PACKAGES_TO_UPGRADE="${@:2}"
PACKAGE_COUNT="$(( $# - 1 ))"
BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)
BEER_ICON=$HOME/.homebrew-notifier/beer-icon.png
BREW_UPDATE_LOG=/tmp/homebrew-notifier-update.log

if [ -n "$PACKAGES_TO_UPGRADE" ] && [ $PACKAGE_COUNT -gt 0 ]; then
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon $BEER_ICON \
        -title "Homebrew Updating..." \
        -subtitle "Update in progress" \
        -message "Updating $PACKAGE_COUNT formulae..."

    $BREW upgrade $(echo $PACKAGES_TO_UPGRADE) 2>&1 >> $BREW_UPDATE_LOG
    BREW_UPGRADE_STATUS=$?
fi


if [ -n "$CLEANUP" ] && $CLEANUP; then
    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon $BEER_ICON \
        -title "Homebrew Cleaning..." \
        -subtitle "Cleanup in progress" \
        -message "Removing old versions, downloads, and caches."

    $BREW cleanup
fi

if [ -n "$BREW_UPGRADE_STATUS" ]; then
    if [ $BREW_UPGRADE_STATUS -eq 0 ]; then
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -appIcon $BEER_ICON \
            -title "Homebrew Updates Complete" \
            -subtitle "Successfully updated the following formulae:" \
            -message "$PACKAGES_TO_UPGRADE" \
            -sound default
    else
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -appIcon $BEER_ICON \
            -title "Homebrew Updates Failed" \
            -subtitle "Failed to update some or all of the following formulae:" \
            -message "$PACKAGES_TO_UPGRADE" \
            -sound default \
            -execute "open $BREW_UPDATE_LOG"
    fi
fi
