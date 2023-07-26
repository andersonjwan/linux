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

# Initialize all DNF-related procedures.
function init() {
    # Enable RPM Fusion-based repositories
    sudo dnf install --nogpgcheck \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf --assumeyes install createrepo
}

# Install all DNF custom repositories.
#
# This allows custom groups of packages to be installed from local repository lists, accordingly.
function initRepositories() {
    for repo in repos/*/ ; do
	reponame=$(basename $repo)

	createRepo $reponame
	initGroup "$repo/comps.xml" $reponame
    done
}

# Do the thing to bootstrap it.
function doIt() {
    init;
    initRepositories;
}

doIt;
