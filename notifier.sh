#!/bin/bash
#
# Homebrew Update Notifier
# Original Author: Chris Streeter <http://www.chrisstreeter.com>

BREW=$(which brew)
TERMINAL_NOTIFIER=$(which terminal-notifier)

$BREW update > /dev/null 2>&1
outdated=$($BREW outdated --quiet)
pinned=$($BREW list --pinned)

outdated=$(comm -1 -3 <(echo "$pinned") <(echo "$outdated"))

if [ -n "$outdated" ]; then
    if [ -e "$TERMINAL_NOTIFIER" ]; then
        lc=$(echo "$outdated" | wc -l)
        outdated=$(echo "$outdated" | tail -n "$lc")
        message=$(echo "$outdated" | head -n 5)
        if [ "$outdated" != "$message" ]; then
            message="Some of the outdated formulae are:
$message"
        else
            message="The following formulae are outdated:
$message"
        fi
        $TERMINAL_NOTIFIER -sender com.apple.Terminal \
            -title "Homebrew Updates Available" -message "$message"
    fi
fi
