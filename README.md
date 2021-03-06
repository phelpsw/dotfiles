## Phelps' dotfiles

All the dotfiles

### Installation
```
cd
git clone git@github.com:phelpsw/dotfiles.git
cd dotfiles
./install.sh
```

### Firefox Bookmarks
1. Open about:config
1. Set tokenserver.uri ```https://argus.williamslabs.com/token/1.0/sync/1.5```
1. Login to firefox sync

### Weechat
```
/secure passphrase <passphrase>
/secure set slack_token <slack token 1>,<slack token 2>
/set plugins.var.python.slack_extension.slack_api_token ${sec.data.slack_token}
/server add spotchat irc.spotchat.org/6697 -ssl
/join #linuxmint-help
/server add oftc irc.oftc.net/6697 -ssl
/join #kernelnewbies
/server add freenode chat.freenode.net/6697 -ssl -autojoin
/server add irc.gnome.org irc.gnome.org/6697 -ssl -ssl_verify
/set irc.look.smart_filter on
/filter add irc_smart * irc_smart_filter *
```

### Mint Cinnamon 18 gnome-keyring fails to work as an ssh-agent
Disable keyring from being used as ssh-agent.  Defaults back to ssh-agent.
Requires ```ssh-add``` to be run at login to register keys with the agent.

https://www.earth.li/~noodles/blog/2016/07/ssh-agent-confirmation.html

```
(cat /etc/xdg/autostart/gnome-keyring-ssh.desktop ;
 echo 'X-GNOME-Autostart-enabled=false') > \
 ~/.config/autostart/gnome-keyring-ssh.desktop
```

