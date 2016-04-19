Manual Installation steps for Ubuntu 14.04 LTS
==============================================

These set of instructions are a bit opinionated but they do work just fine and can be used if rails installation script doesn't work for the project. The setup is tested against Ubuntu 14.04 LTS 64-bit OS version.

# Steps
Assuming a fresh ubuntu installation, please follow the instructions in given order

## Update and upgrade packages
```
sudo apt-get update
sudo apt-get upgrade
```

## Install nvm (node version manager)
```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
```

## Install latest version of nodejs
```
nvm install 5.10.1
nvm use 5.10.1
```

## Install phantomjs npm package
```
npm install -g phantomjs
```

Note to run `nvm use ..` before you start any work. Unfortunately there is no workaround. There is a .nvmrc file option won't work like rvm config files

## Install git (Version Control)
```
sudo apt-get install git
```



