# Homebrew Notifier

Notifies you when homebrew package updates are available. An extension of
[`brew-update-notifier.sh`](https://gist.github.com/streeter/3254906) with an
added script to idempotently install it as a daily cron task.

## Installation

```
curl -fsS https://raw.githubusercontent.com/grantovich/homebrew-notifier/master/install.sh | sh
```

Note: default behavior is to prompt for upgrades, if any are available. To
change this, see usage below.

##Usage
Cron will execute the notifier script daily, which will check for any oudated,
unpinned formulae.

###Upgrade
```
--upgrade [prompt, auto]
```
Providing the upgrade option with a value of `prompt` (default) will cause the
notifier to display a notification when updates are available. When this
notification is clicked, these formulae will be upgraded. Providing a value of
`auto` will cause these formulae to be updated automatically.

After the upgrade process is complete, a notification will be displayed
indicating if the upgrades succeeded or failed.
