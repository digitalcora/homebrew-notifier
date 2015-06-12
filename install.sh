#!/bin/sh

NOTIFIER_URL=https://raw.githubusercontent.com/grantovich/homebrew-notifier/master/notifier.sh

brew install terminal-notifier
mkdir -p ~/.bin
curl -fsS $NOTIFIER_URL > ~/.bin/brew-update-notifier.sh

if crontab -l | grep -q 'brew-update-notifier'; then
  echo 'Crontab entry already exists, skipping...'
else
  echo "0 11 * * * PATH=/usr/local/bin:\$PATH $(echo ~)/.bin/brew-update-notifier.sh" | crontab -
fi

echo
echo "Notifier installed. You'll be notified of brew updates at 11am every day."
echo "Checking for updates right now..."
~/.bin/brew-update-notifier.sh
