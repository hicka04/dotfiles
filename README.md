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

## Configure zsh
```
cp ~/ghq/github.com/hicka04/dotfiles/.zshenv.example ~/.zshenv
```

```
vim ~/.zshenv

DOTFILES_HOME=$HOME/ghq/github.com/hicka04/dotfiles
```

```
mkdir -p $(dirname $HISTFILE) && touch $HISTFILE
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
