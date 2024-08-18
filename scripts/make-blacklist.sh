#!/bin/bash

set -e

function get_blacklists() {
    curl --silent --location 'https://v.firebog.net/hosts/lists.php?type=tick' \
        | xargs -I {} curl {} \
        | grep -v -e '#' -e '!' -e 'localhost'
}

function lower() {
    tr '[:upper:]' '[:lower:]'
}

function trim() {
    sed 's/ *//' | sed 's/ *$//'
}

function filter() {
    sed '/[^a-zA-Z0-9\._\-]/d' | sed '/^$/d' | sed '/^-.*$/d' | sed '/^.*-$/d'
}

function clean() {
    sed 's/||\(.*\)\^$/\1/' \
        | sed 's/\([[:digit:]]\+\.\)\{3\}[[:digit:]] //'
}

cd $(dirname $0)
rm ../data/blacklist.txt
touch ../data/blacklist.txt
export LC_ALL='C'
get_blacklists \
    | lower \
    | trim \
    | clean \
    | filter \
    | sort \
    | uniq \
    > ../data/blacklist.txt
