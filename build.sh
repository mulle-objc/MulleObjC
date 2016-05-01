#! /bin/sh

set -e
mulle-bootstrap build "$@" -c Debug -k

#xcodebuild -configuration Release -scheme Libraries
xcodebuild -configuration Debug -scheme Libraries
