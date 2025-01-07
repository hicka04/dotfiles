# dotfiles
## Install Homebrew
See https://brew.sh/

## Install ghq
```
brew install ghq
```

## Clone
### Connect to GitHub using ssh
https://docs.github.com/ja/authentication/connecting-to-github-with-ssh

### Get
```
ghq get git@github.com:hicka04/dotfiles.git
```

## Configure env
```
cp setenvs.plist $HOME/Library/LaunchAgents/dev.hicka04.setenvs.plist
vim $HOME/Library/LaunchAgents/dev.hicka04.setenvs.plist # replace {username}
launchctl load $HOME/Library/LaunchAgents/dev.hicka04.setenvs.plist
```

## Configure zsh
```
sudo ln -s $DOTFILES_HOME/zshenv /etc/zshenv
```

```
mkdir -p $(dirname $HISTFILE) && touch $HISTFILE
```

## Install commands and apps
```
cd path/to/Brewfile
brew bundle
```

## Configure git
```
git config --global user.name hicka04
git config --global user.email hicka04@gmail.com
```

## Configure karabiner
```
ln -s $XDG_CONFIG_HOME/karabiner ~/.config/karabiner
```

## Configure Xcode
### Color theme
```
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
ln -s ~/ghq/github.com/hicka04/dotfiles/Xcode/Monokai.xccolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes/Monokai.xccolortheme
```
