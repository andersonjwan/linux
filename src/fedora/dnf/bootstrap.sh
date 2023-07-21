#!/usr/bin/env bash

# Bootstrap DNF-related items.
# @author "Jacob Anderson <andersonjwan@gmail.com>"

# Set working directory to this file's root directory.
cd "$(dirname "${BASH_SOURCE}")";

# Create repository.
#
# @param $1 Repository name.
function createRepo() {
    local path="/usr/share/repository/$1";
    local repofile="$path/$1.repo";

    mkdir --parents "$path";
    createrepo --quiet "$path";
    echo "[DEBUG] bootstrap: dnf: created repository... $path";

    cp "repos/$1/$1.repo" /etc/yum.repos.d/
    echo "[DEBUG] bootstrap: dnf: installed repository configuration file... /etc/yum.repos.d/$1.repo";
}

# Copy group configuration to repository.
#
# @param $1 Path to group configuration file.
# @param $2 Repository name.
function initGroup() {
    local repodir="/usr/share/repository/$2";
    local groupfile="$(basename $1)";

    cp $1 "$repodir/repodata/";
    createrepo --quiet --groupfile="$repodir/repodata/$groupfile" "$repodir";

    echo "[DEBUG] bootstrap: dnf: initialized group... $repodir/repodata/$groupfile";
}

# Do the thing to bootstrap it.
function doIt() {
    sudo dnf --assumeyes install createrepo

    for repo in repos/*/ ; do
	reponame=$(basename $repo)

	createRepo $reponame
	initGroup "$repo/comps.xml" $reponame
    done
}

doIt;
