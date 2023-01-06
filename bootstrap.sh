#!/usr/bin/env bash

# Bootstrap Fedora post-installation.
# @author "Jacob Anderson <andersonjwan@gmail.com>"

# Set working directory to this file's root directory.
cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    source dnf/bootstrap.sh 
}

# Bootstrap Fedora.
#
# @option --force -f Force the boostrap process carelessly.
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files throughout your system. Are you sure (y/n) " -n 1;
    echo "";

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
