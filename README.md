# Homebrew Notifier

Notifies you when homebrew package updates are available, and provides the
option of upgrading them. An extension of
[`brew-update-notifier.sh`](https://gist.github.com/streeter/3254906) with an
added script to idempotently install it as a daily cron task.

## Installation

```
curl -fsS https://raw.githubusercontent.com/grantovich/homebrew-notifier/master/install.sh | sh
```

Note: default behavior is to prompt for upgrades and perform cleanup after
upgrades. To change this, see usage below.

## Usage
Cron will execute the notifier script daily, which will check for any
outdated, unpinned formulae.

###Upgrade
```
--upgrade [prompt, auto]
```
Providing the upgrade option with a value of `prompt` (default) will cause the
notifier to display a notification when updates are available, that when
clicked will upgrade those formulae. Providing a value of `auto` will cause the
notifier to always upgrade any outdated packages automatically.

After the upgrade process is complete, a notification will be displayed
indicating either success or failure. In the event of a failure, you can click
the notification to view a log of the failed upgrade process.

###Cleanup
```
--cleanup
```
Providing the cleanup option will perform a `brew cleanup` after upgrading
packages.
