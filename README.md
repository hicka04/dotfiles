# dotfiles

## Install ghq
```
brew install ghq
```

## Clone
```
ghq get git@github.com:hicka04/dotfiles.git
```

## Configure .zshenv
```
cp ~/ghq/github.com/hicka04/dotfiles/.zshenv.example ~/.zshenv
```

```
vim ~/.zshenv

DOTFILES_HOME=$HOME/ghq/github.com/hicka04/dotfiles
```
