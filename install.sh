#!/bin/bash

install_trk (){
    path="$1"
    cd trk
    cp trk.fish "$path"
    chmod +x "$path"
    cd ..
}

install_trks () {
    path="$1"
    cd trks
    stack build
    cp ".stack-work/dist/x86_64-linux/Cabal-3.4.1.0/build/time-tracker-exe/time-tracker-exe" "$path"
    chmod +x "$path"
    cd ..
}

install_trk "$HOME/bin/trk"

# Install for user
install_trks "$HOME/bin/trks"

# Install for webserver
install_trks "../web/programs/trks"
