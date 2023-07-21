#!/usr/bin/env bash

# Bootstrap for Linux post-installations.
# @author "Jacob Anderson <andersonjwan@gmail.com>"

# Set working directory to this file's root directory.
cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    source src/bootstrap.sh
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
