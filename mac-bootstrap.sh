#!/usr/bin/env bash

##################################################
#           Developer tool installs & config
##################################################

# Install mac developer tools
xcode-select --install

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Tap cask for GUI tools
brew tap homebrew/cask

# Cask installs
brew install --cask postman \
                    google-chrome \
                    visual-studio-code \
                    slack \
                    spotify \
                    iterm2  \
                    docker \
                    drawio \
                    google-cloud-sdk

# Brew installs
brew install git \
             python \
             pipenv \
             go \
             node \
             zsh \
             kubernetes-helm \
             docker-machine \
             kubectl \
             warrensbox/tap/tfswitch \
             wget \
             map \
             speedtest-cli \
             yq \
             azure-cli

# Pip installs
pip install requests \
            boto3 botocore \
            urllib3 \
            awscli \
            pytest

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# upgrade_oh_my_zsh

# Set gopath
echo 'export PATH="${HOME}/go/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

##################################################
#           macOS configuration
##################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Create code directory and set it as default dir for new finder windows
mkdir ~/Code
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Code/"

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Configure screenshot save directory
mkdir ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

# Enable dark mode
defaults write "Apple Global Domain" "AppleInterfaceStyle" "Dark"

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false


##################################################
#           Asset Downloads
##################################################

# Download AWS icons 
# mkdir -p ${HOME}/Pictures/AWS/

# cd ${HOME}/Pictures/AWS/
# curl https://d1.awsstatic.com/webteam/architecture-icons/AWS-Architecture-Icons_PNG_20191031.2d59c1fa62de714961b0a1d664b6753c6d808306.zip --output ${HOME}/Pictures/AWS/AWS-Architecture-Icons_PNG.zip
# curl https://d1.awsstatic.com/webteam/architecture-icons/AWS-Architecture-Icons_SVG_20191031.37913bbe8450d38bc7acc50cc40fe0c2135d650c.zip --output ${HOME}/Pictures/AWS/AWS-Architecture-Icons_SVG.zip

# unzip AWS-Architecture-Icons_PNG.zip
# unzip AWS-Architecture-Icons_SVG.zip