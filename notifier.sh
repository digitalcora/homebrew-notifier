#!/bin/bash

# Capture ouput for logs
LOG="/usr/local/var/log/homebrew-notifier.log"
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>$LOG 2>&1

echo "$(date) - Start notifier script"

UPGRADE="off"
CLEANUP=false
while [[ $# -ge 1 ]]
do
    key="$1"
    case $key in
        "--upgrade")
            UPGRADE="$2"
            shift
            ;;
        "--cleanup")
            CLEANUP=true
            shift
            ;;
        *)
            echo "unknown"
            # unknown option
            ;;
    esac
    shift
done

echo "upgrade=$UPGRADE"
echo "cleanup=$CLEANUP"

BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)
NOTIFIER_PATH=$HOME/.homebrew-notifier
BEER_ICON=$NOTIFIER_PATH/beer-icon.png
UPGRADE_SCRIPT=$NOTIFIER_PATH/upgrade.sh
UPGRADE_COMMAND="PATH=/usr/local/bin:\$PATH $UPGRADE_SCRIPT"

echo "Updating brew..."

$BREW update > /dev/null 2>&1

outdated=$($BREW outdated --quiet)
pinned=$($BREW list --pinned)
updatable=$(comm -1 -3 <(echo "$pinned") <(echo "$outdated") | xargs)

if [ -n "$updatable" ] && [ -e "$TERMINAL_NOTIFIER" ]; then
    echo "Packages found to update: $updatable"

    if [ "$UPGRADE" = "auto" ] && [ -f "$UPGRADE_SCRIPT" ]; then
        $UPGRADE_SCRIPT $CLEANUP "$updatable"
    elif [ "$UPGRADE" = "prompt" ] && [ -f "$UPGRADE_SCRIPT" ]; then
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -appIcon "$BEER_ICON" \
            -title "Homebrew Updates Available" \
            -subtitle "Click here to update the following formulae:" \
            -message "$updatable" \
            -sound default \
            -execute "$UPGRADE_COMMAND $CLEANUP $updatable"
    else
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -appIcon "$BEER_ICON" \
            -title "Homebrew Updates Available" \
            -subtitle "The following formulae are outdated:" \
            -message "$updatable" \
            -sound default
    fi
else
    echo "No updates available"
fi

echo "$(date) - End notifier script"
