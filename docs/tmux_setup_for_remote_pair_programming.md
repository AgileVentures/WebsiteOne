### Installation script ###

You can launch Amazon EC2 instance for "free tier eligible" or you can use any other hosting.
If you launch Ubuntu server you can execute a script that installs all the necessary software on your server.

Clone and run the [setup script](https://github.com/coddeys/setup).
```sh
cd $HOME
sudo apt-get install -y git-core
git clone https://github.com/coddeys/setup.git
chmod +x ./setup/*.sh
./setup/setup.sh
```

### Getting started ###

* Run ``sudo passwd ubuntu``, create password for default user (ubuntu). 
* Run ``chsh -s /bin/zsh``, change default shell from bash to zsh.
* Run ``gh-auth add --users=GITHUB_USERNAME``, github-auth allows you to quickly pair with anyone who has a GitHub account by adding and removing their public ssh keys from your ``authorized_keys`` file.

#### Tmux ####
* A user-specific configuration file should be located at ``~/.tmux.conf``
* The prefix key (Ctrl-b) changed to (\`) because (Ctrl-b) is not acceptable, due to emacs, bash, and vim
* Run ``tmux`` Strat a new session
* ``\` b OR \` :detach `` Detach from currently attached session
* Run ``tmux ls OR tmux list-sessions`` list sessions
* Run ``tmux attach`` re-attach a detached session

### Installation WebsiteOne ###

The script also clones the WebsiteOne project and runs all the steps needed to set up the development enviroment for you.

Run ``./setup/wso_welcome.sh``
