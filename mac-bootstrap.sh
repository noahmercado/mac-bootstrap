#!/usr/bin/env bash

set -e 

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command exited with exit code $?."' exit

##################################################
#           Developer tool installs & config
##################################################

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

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
brew install go \
             node \
             helm \
             kubectl \
             warrensbox/tap/tfswitch \
             wget \
             nmap \
             speedtest-cli \
             yq \
             azure-cli \
             awscli

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Clone git repo
git clone https://github.com/noahmercado/mac-bootstrap.git && cd mac-bootstrap

# Setup dotfiles
cp .zshrc ${HOME}/.zshrc
cp -r dotfiles ${HOME}/.dotfiles

sed -i '' "s#HOME_DIR#${HOME}#g" "${HOME}/.zshrc"

##################################################
#           VS Code configuration
##################################################
ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code

# Install VS Code extensions
while IFS= read -r e; do
  code --install-extension $e
done < extensions.txt


##################################################
#          Git configuration
##################################################

mkdir -p "${HOME}/.ssh"

# Create ssh key
key_path="${HOME}/.ssh/github"
create_key_cmd="ssh-keygen -t ed25519 -f $key_path -N \"\""
if [[ "$USER_EMAIL" != "" ]]
then
    create_key_cmd+=" -C $USER_EMAIL"
fi

eval $create_key_cmd

# Add to SSH agent
ssh-add "${key_path}"

# Conditionally upload public key to Github
pub_key=`cat ${key_path}.pub`

if [[ "$GITHUB_TOKEN" != "" ]] && [[ "$GITHUB_USER" != "" ]]
then
    payload="{\"title\":\"`hostname`\",\"key\":\"$pub_key\"}"
    curl -u "$GITHUB_USER:$GITHUB_TOKEN" -X POST -d "$payload" https://api.github.com/user/keys
fi

ssh_config_path="${HOME}/.ssh/config"

if [[ ! -f "${ssh_config_path}" ]]
then
    # Copy ssh config file
    cp sshconfig ${ssh_config_path}
else
    echo "" >> ${ssh_config_path}
    cat sshconfig >> ${ssh_config_path}
fi
sed -i '' "s#KEY_PATH#${key_path}#g" "${ssh_config_path}"

##################################################
#           macOS configuration
##################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Create code directory and set it as default dir for new finder windows
mkdir ${HOME}/Code
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Code/"

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Configure screenshot save directory
mkdir ${HOME}/Screenshots
defaults write com.apple.screencapture location ${HOME}/Screenshots

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

source ${HOME}/.zshrc