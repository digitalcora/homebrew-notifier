#!/bin/bash

#Capture output for logs
LOG="/usr/local/var/log/homebrew-notifier.log"
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>$LOG 2>&1

echo "$(date) - Start upgrade script"

CLEANUP=$1
PACKAGES_TO_UPGRADE="${*:2}"
PACKAGE_COUNT="$(( $# - 1 ))"
BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)
BEER_ICON=$HOME/.homebrew-notifier/beer-icon.png

if [ -n "$PACKAGES_TO_UPGRADE" ] && [ $PACKAGE_COUNT -gt 0 ]; then
    echo "Updating packages: $PACKAGES_TO_UPGRADE"

    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon "$BEER_ICON" \
        -title "Homebrew Updating..." \
        -subtitle "Update in progress" \
        -message "Updating $PACKAGE_COUNT formulae..."

    $BREW upgrade $(echo -n "$PACKAGES_TO_UPGRADE")
    BREW_UPGRADE_STATUS=$?
else
    echo "No packages provided to update!"
fi


if [ -n "$CLEANUP" ] && $CLEANUP; then
    echo "Cleaning brew..."

    $TERMINAL_NOTIFIER -sender com.apple.Terminal \
        -appIcon "$BEER_ICON" \
        -title "Homebrew Cleaning..." \
        -subtitle "Cleanup in progress" \
        -message "Removing old versions, downloads, and caches."

    $BREW cleanup > /dev/null 2>&1
fi

if [ -n "$BREW_UPGRADE_STATUS" ]; then
    if [ $BREW_UPGRADE_STATUS -eq 0 ]; then
        echo "Upgrades successful! 🍻"

        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -appIcon "$BEER_ICON" \
            -title "Homebrew Updates Complete" \
            -subtitle "Successfully updated the following formulae:" \
            -message "$PACKAGES_TO_UPGRADE" \
            -sound default \
            -execute "say 🍺"
    else
        echo "Upgrades failed!"

        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -appIcon "$BEER_ICON" \
            -title "Homebrew Updates Failed" \
            -subtitle "Failed to update some or all of the following formulae:" \
            -message "$PACKAGES_TO_UPGRADE" \
            -sound default \
            -execute "open $LOG"
    fi
else
    echo "No updates performed"
fi

echo "$(date) - End upgrade script"
