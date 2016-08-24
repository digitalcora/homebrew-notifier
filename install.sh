#!/bin/sh

BASE_URL=https://raw.githubusercontent.com/grantovich/homebrew-notifier/master
NOTIFIER_PATH=$HOME/.homebrew-notifier
NOTIFIER_SCRIPT=$NOTIFIER_PATH/notifier.sh
UPDATE_SCRIPT=$NOTIFIER_PATH/upgrade.sh

brew list | grep -q "terminal-notifier" || brew install terminal-notifier
mkdir -p "$NOTIFIER_PATH"
curl -fsS $BASE_URL/notifier.sh > "$NOTIFIER_SCRIPT"
curl -fsS $BASE_URL/upgrade.sh > "$UPDATE_SCRIPT"
chmod +x "$NOTIFIER_SCRIPT"
chmod +x "$UPDATE_SCRIPT"

if crontab -l | grep -q "notifier\.sh"; then
  echo "Crontab entry already exists, skipping..."
else
  echo "0 11 * * * PATH=/usr/local/bin:\$PATH $NOTIFIER_SCRIPT --upgrade prompt" | crontab -
fi

echo
echo "Notifier installed. You'll be notified of brew updates at 11am every day."
echo "Checking for updates right now..."
$NOTIFIER_SCRIPT --upgrade prompt
