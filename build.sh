#! /bin/sh

set -e
mulle-bootstrap build "$@"

xcodebuild -configuration Release -scheme Libraries
xcodebuild -configuration Debug -scheme Libraries
