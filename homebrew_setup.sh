#!/bin/zsh

cd ~/
# Copy default profile file to the .zprofile
cp ~/macOS_setup_scripts/profile.txt .zprofile

# Install homebrew package manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install utils
echo "Installing utils"
brew install wget
brew install git
brew install composer
brew install nvm
brew install cocoapods

# Install laguages
echo "Installing languages"
brew install python@3.8
brew install java11

# Install apps
echo "Installing apps"
brew cask install firefox
brew cask install brave-browser
brew cask install react-native-debugger
brew cask install spotify
brew cask install postman
brew cask install android-studio
brew cask install visual-studio-code

# Set up Iterm
echo "Setting up Terminal"
# Install Item2
brew cask install iterm2
# Install oh_my_zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
# Copy zshrc template to .zshrc file
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Install node version
echo "Installing Node"
nvm install v12.18.3
eval "nvm alias default node"

# Install global npm packages
echo "Installing global NPM packages"
npm install -g yarn
npm install -g create-react-app
npm install -g make-react-component
npm install -g typescript

# Set up scripts and code dirs
echo "Setting up working dirs and script dirs"
cd ~/
mkdir scripts
mkdir code
cd scripts
git clone https://github.com/lvstross/git_tools.git

# source the .zshrc file and the .zprofile in the current terminal session
echo "Sourcing the zfiles"
source ~/.zshrc
source ~/.zprofile