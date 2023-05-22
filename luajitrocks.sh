#!/bin/bash
#if on windows download instead: https://github.com/rjpcomputing/luaforwindows
is_termux=false

# Check if running on Termux
if [[ "$1" == "--termux" ]]; then
    is_termux=true
fi

# Install LuaJIT
install_luajit() {
    if [[ "$is_termux" == "true" ]]; then
        pkg update
        pkg install -y luajit
    elif [[ "$(uname)" == "Darwin" ]]; then
        brew install luajit
    elif [[ "$(uname)" == "Linux" ]]; then
        sudo apt-get update
        sudo apt-get install -y luajit
    else
        echo "Unsupported operating system\nIf on Windows download: https://github.com/rjpcomputing/luaforwindows"
        exit 1
    fi
}

# Install LuaRocks
install_luarocks() {
    if [[ "$is_termux" == "true" ]]; then
        pkg install -y make
        pkg install -y unzip
    elif [[ "$(uname)" == "Darwin" ]]; then
        brew install make
        brew install unzip
    elif [[ "$(uname)" == "Linux" ]]; then
        sudo apt-get install -y make
        sudo apt-get install -y unzip
    else
        echo "Unsupported operating system\nIf on Windows download: https://github.com/rjpcomputing/luaforwindows"
        exit 1
    fi

    wget https://luarocks.github.io/luarocks/releases/luarocks-3.9.2.tar.gz
    tar zxvf luarocks-3.9.2.tar.gz
    cd luarocks-3.9.2
    ./configure --with-lua-include=/usr/include/luajit-2.1
    make
    sudo make install

    # Clean up
    cd ..
    rm -rf luarocks-3.9.2.tar.gz luarocks-3.9.2
}

# Run installation steps
install_luajit
install_luarocks

echo "LuaJIT and LuaRocks installed successfully."
