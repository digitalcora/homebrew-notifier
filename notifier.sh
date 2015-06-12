#!/bin/bash
#
# Homebrew Update Notifier
# Original Author: Chris Streeter <http://www.chrisstreeter.com>

TERM_APP='/Applications/Terminal.app'
BREW_EXEC='/usr/local/bin/brew'
TERMINAL_NOTIFIER=`which terminal-notifier`
NOTIF_ARGS="-sender com.apple.Terminal"

$BREW_EXEC update 2>&1 > /dev/null
outdated=`$BREW_EXEC outdated --quiet`
pinned=`$BREW_EXEC list --pinned`

# Remove pinned formulae from the list of outdated formulae
outdated=`comm -1 -3 <(echo "$pinned") <(echo "$outdated")`

if [ -z "$outdated" ] ; then
    if [ -e $TERMINAL_NOTIFIER ]; then
        # No updates available
        $TERMINAL_NOTIFIER $NOTIF_ARGS \
            -title "No Homebrew Updates Available" \
            -message "No updates available yet for any homebrew packages."
    fi
else
    # We've got an outdated formula or two

    # Nofity via Notification Center
    if [ -e $TERMINAL_NOTIFIER ]; then
        lc=$((`echo "$outdated" | wc -l`))
        outdated=`echo "$outdated" | tail -$lc`
        message=`echo "$outdated" | head -5`
        if [ "$outdated" != "$message" ]; then
            message="Some of the outdated formulae are:
$message"
        else
            message="The following formulae are outdated:
$message"
        fi
        # Send to the Nofication Center
        $TERMINAL_NOTIFIER $NOTIF_ARGS \
            -title "Homebrew Update(s) Available" -message "$message"
    fi
fi
