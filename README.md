# dotfiles

## Install ghq
```
brew install ghq
```

## Clone
```
ghq get git@github.com:hicka04/dotfiles.git
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
touch $HISTFILE
```

## Configure karabiner
```
ln -s $XDG_CONFIG_HOME/karabiner ~/.config/karabiner
```

## Install commands and apps
### Install homebrew
See https://brew.sh/

### Install by Brewfile
```
brew bundle
```
