#!/bin/bash

UPGRADE="off"
while [[ $# -ge 1 ]]
do
    key="$1"
    case $key in
        "--upgrade")
            UPGRADE="$2"
            shift
            ;;
        *)
            # Unknown option
            ;;
    esac
    shift
done

BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)
NOTIFIER_PATH=$HOME=/.homebrew-notifier
UPGRADE_SCRIPT=$NOTIFIER_PATH/.upgrade.sh
UPGRADE_COMMAND="PATH=/usr/local/bin:\$PATH $UPGRADE_SCRIPT"

$BREW update > /dev/null 2>&1

outdated=$($BREW outdated --quiet)
pinned=$($BREW list --pinned)
updatable=$(comm -1 -3 <(echo "$pinned") <(echo "$outdated") | xargs)

if [ -n "$updatable" ] && [ -e "$TERMINAL_NOTIFIER" ]; then
    if [ "$UPGRADE" = "auto" ] && [ -f "$UPGRADE_SCRIPT" ]; then
        $UPGRADE_SCRIPT "$updatable"
    elif [ "$UPGRADE" = "prompt" ] && [ -f "$UPGRADE_SCRIPT" ]; then
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \¬
        -title "Homebrew Updates Available" \¬
        -subtitle "Click here to update the following formulae:" \¬
        -message "$updatable" \¬
        -sound default \¬
        -execute "$UPGRADE_COMMAND $updatable"¬
    else¬
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \¬
        -title "Homebrew Updates Available" \¬
        -subtitle "The following formulae are outdated:" \¬
        -message "$updatable" \¬
        -sound default
    fi
fi
