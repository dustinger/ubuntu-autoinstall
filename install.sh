#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential git curl wget zsh tmux python3 python3-pip python3-venv postgresql postgresql-contrib libpq-dev docker.io docker-compose apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# Set up Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Install RVM and latest Ruby
if ! command -v rvm &> /dev/null; then
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm reload
    rvm install ruby --latest  # Install the latest stable Ruby
    gem install bundler
    gem install rails
else
    echo "RVM already installed"
fi

# Install the latest Go
GO_LATEST_VERSION=$(curl -s https://golang.org/VERSION?m=text)
wget https://golang.org/dl/${GO_LATEST_VERSION}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf ${GO_LATEST_VERSION}.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Set up Python virtual environment and upgrade pip
python3 -m pip install --upgrade pip
python3 -m pip install virtualenv

# Install latest Node.js and Yarn
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -   # Use "current" for the latest Node.js version
sudo apt install -y nodejs
sudo npm install -g yarn
sudo npm install -g eslint

# Set up Docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

# Install latest VSCode
if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
else
    echo "VSCode already installed"
fi

# Install VSCode extensions
code --install-extension rebornix.ruby
code --install-extension ms-python.python
code --install-extension golang.go
code --install-extension dbaeumer.vscode-eslint
code --install-extension bung87.rails
code --install-extension eamodio.gitlens

# Install latest Postman
if ! command -v postman &> /dev/null; then
    wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux.tar.gz
    sudo tar -xzf postman-linux.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/local/bin/postman
else
    echo "Postman already installed"
fi

# Install latest DBeaver
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt update
sudo apt install -y dbeaver-ce

# Install Oh-My-Zsh (latest)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s $(which zsh)
    echo "source ~/.zshrc" >> ~/.bashrc
else
    echo "Oh-My-Zsh already installed"
fi

# Install the latest nvm and latest Node.js using nvm
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install node  # This will install the latest Node.js version
    nvm use node
else
    echo "nvm already installed"
fi

# Install the latest pyenv for Python version management
if ! command -v pyenv &> /dev/null; then
    curl https://pyenv.run | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    source ~/.bashrc
    pyenv install $(pyenv install --list | grep -v - | tail -1)  # Install the latest Python version
else
    echo "pyenv already installed"
fi

# Enable Docker for the current user (avoid sudo)
newgrp docker

# Enable PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "Latest development environment setup complete!"
