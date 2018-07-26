#!/bin/sh

# 2018-07-25
# by Johnnie H.
# sets up a new sofi kraken host by:
# 1) copying my .ssh directory
# 2) setup $HOME as a clone of my SoFi Home repository

[ $# -lt 1 ] && echo "usage: $0 KRAKEN_HOST" && exit 1

host=$1
target_dir="~"

# copy your .ssh directory to kraken instance
scp -rp ~/.ssh ${host}:${target_dir}/
echo "Completed scp of .ssh"

# make $home directory into a git repo if not already
ssh ${host} "[ ! -d ${target_dir}/.git ] && cd ${target_dir};git init"
echo "Completed git init"

# copy my sofi home repo config to $host
ssh ${host} "cat > ${target_dir}/.git/config" << EOF
[core]
  repositoryformatversion = 0
  filemode = true
  bare = false
  logallrefupdates = true
  ignorecase = true
  precomposeunicode = true
  commitGraph = true
[remote "origin"]
  url = jaxis5@bitbucket.org:jaxis5/vm_home.git
  fetch = +refs/heads/*:refs/remotes/origin/*
  pushurl = jaxis5@bitbucket.org:jaxis5/vm_home.git

[branch "master"]
  remote = origin
  merge = refs/heads/master
EOF
echo "Completed adding git config"

# after updating the configuration, do a git pull
ssh ${host} "cd ${target_dir}; git fetch --all; git reset --hard origin/master"
echo "Completed git fetch/reset"
