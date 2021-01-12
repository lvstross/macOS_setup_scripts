#!/bin/zsh

echo "Running New Computer Set up..."

# Some configs reused from:
# https://github.com/ruyadorno/installme-osx/
# https://gist.github.com/millermedeiros/6615994
# https://gist.github.com/brandonb927/3195465/
# https://github.com/nnja/new-computer/blob/master/setup.sh

# Colorize

# Set the colors you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`

# Color-echo function
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}

echo ""
cecho "###############################################" $red
cecho "#        DO NOT RUN THIS SCRIPT BLINDLY       #" $red
cecho "#         YOU'LL PROBABLY REGRET IT...        #" $red
cecho "#                                             #" $red
cecho "#              READ IT THOROUGHLY             #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

# Set continue to false by default.
CONTINUE=false

echo ""
cecho "Have you read through the script you're about to run and " $red
cecho "understood that it will make changes to your computer? (y/n)" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" $red
  exit
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Start at users home directory
cd ~/
# Copy default profile file to the .zprofile
cp ~/macOS_setup_scripts/profile.txt .zprofile
echo "Created .zprofile"


###########################
#        Homebrew         #
###########################

echo "Installing homebrew..."

if test ! $(which brew)
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Latest brew, install brew cask
echo "Updating Homebrew and tapping cask repo"
brew update
brew tap homebrew/cask

# Install utils
echo "Installing homebrew utils packages"
brew install wget 
brew install git
brew install composer
brew install trash
brew install nvm
brew install cocoapods

# Install laguages
echo "Installing languages"
brew install python@3.8 # Python language
brew install pyenv # Python development environment tool
brew install java11 # Java language

# Install databases
echo "Installing databases"
brew tap mongodb/brew
brew install mongodb-community@4.4 # Preffered document database
brew install postgresql # Preffered relational database

# Install apps
echo "Installing cask apps"
brew install firefox --cask # web browser
brew install brave-browser --cask # web browser
brew install smcfancontrol --cask # fan control application
brew install docker --cask # vm containers
brew install robo-3t --cask # document database tool
brew install sketch --cask # design tool
brew install intellij-idea --cask # Java IDE
brew install react-native-debugger --cask # Debugger Desktop tool for React Native
brew install iterm2 --cask # Termianl Application
brew install spotify --cask # Music Streaming Service
brew install postman --cask # Network Request Tool
brew install android-studio --cask # IDE for Android Developement
brew install visual-studio-code --cask # General Text Editor
# Quicklook plugins https://github.com/sindresorhus/quick-look-plugins
brew install qlcolorcode --cask # syntax highlighting in preview
brew install qlstephen --cask  # preview plaintext files without extension
brew install qlmarkdown --cask  # preview markdown files
brew install quicklook-json --cask  # preview json files
brew install epubquicklook --cask  # preview epubs, make nice icons
brew install quicklook-csv --cask  # preview csvs

# Run Brew Cleanup
brew cleanup


###########################
# Iterm, Node and Scripts #
###########################

# Set up Iterm
echo "Setting up Terminal"
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
npm install -g create-react-native-app
npm install -g make-react-component
npm install -g @nestjs/cli
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

####################################################################################################
# Set OSX Preferences - Borrowed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos #
####################################################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'


##############################
# Finder, Dock, & Menu Items #
##############################

# ~ defaults - will show defaults help page

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Save to disk (not to iCloud) by default
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Only Show Open Applications In The Dock  
defaults write com.apple.dock static-only -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
#defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Hot corners
# Bottom Left Corner: Misson Control
defaults write com.apple.dock wvous-bl-corner -int 2
# Bottom Right Corner: Launch Pad
defaults write com.apple.dock wvous-br-corner -int 11
# Top Left Corner: Screen Saver
defaults write com.apple.dock wvous-tl-corner -int 5
# Top Right Corner: Notification Center
defaults write com.apple.dock wvous-tr-corner -int 12


# Menu bar: hide the Time Machine, User icons, but show the volume Icon.
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/User.menu" \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

##################
### Text Editing / Keyboards
##################

# Disable smart quotes and smart dashes
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Use function F1, F, etc keys as standard function keys
# defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true


###############################################################################
# Screenshots / Screen                                                        #
###############################################################################

# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Disable “natural” (Lion-style) scrolling
# Uncomment if you don't use scroll reverser
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable force click and haptic feedback
# defaults write ~/Library/Preferences/com.apple.AppleMultitouchTrackpad.plist ForceSuppressed -bool true

# Mouse settings
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseOneFingerDoubleTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseTwoFingerDoubleTapGesture -int 3
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseTwoFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseVerticalScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseHorizontalScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseMomentumScroll -int 1
defaults write ~/Library/Preferences/.GlobalPreferences.plist com.apple.mouse.scaling -float 3
# defaults write ~/Library/Preferences/.GlobalPreferences.plist com.apple.swipescrolldirection -boolean NO

###############################
# Installs from Mac App Store #
###############################

echo "Installing apps from the App Store..."

### find app ids with: mas search "app name"
brew install mas

### Mas login is currently broken on mojave. See:
### Login manually for now.

cecho "Need to log in to App Store manually to install apps with mas...." $red
echo "Opening App Store. Please login."
open "/Applications/App Store.app"
echo "Is app store login complete.(y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ]
then
	mas install 668208984  # GIPHY Capture. The GIF Maker - The GIF Maker (For recording my screen as gif)
	mas install 1351639930 # Gifski - Convert videos to gifs
	mas install 441258766 # Magnet - Window Management
	mas install 915542151 # Monity - System View Widget
	mas install 1528819846 # Stats Panel - System status bar widget
	mas install 824183456 # Affinity Photo - Photo Editor
	mas install 640199958 # Apple Developer - Apple Developer Info
	mas install 1496833156 # Swift Playgrounds - Sandbox environment for swift
	mas install 497799835 # Xcode - Apple Swift Development Environment
else
	cecho "App Store login not complete. Skipping installing App Store Apps" $red
fi

echo ""
cecho "Done!" $cyan
echo ""
echo ""
cecho "################################################################################" $white
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." $red
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ] ;then
    softwareupdate -i -a --restart
fi