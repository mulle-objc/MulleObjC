#! /bin/sh

mulle-bootstrap build mulle-objc-runtime
xcodebuild -configuration Release -scheme Libraries
xcodebuild -configuration Debug -scheme Libraries