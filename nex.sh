#/bin/bash
apt install screen
sudo apt install build-essential pkg-config libssl-dev git-all -y

sudo apt install -y protobuf-compiler

sudo apt install cargo

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc

rustup update

sudo apt remove -y protobuf-compiler

curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip

unzip protoc-25.2-linux-x86_64.zip -d $HOME/.local

export PATH="$HOME/.local/bin:$PATH"

protoc --version
