#! /bin/bash

# Publishes packages in the release directory as local Typst packages,
# by copying them into .../typst/packages/local.
#
# Usage: ./scripts/publish-local.sh


LOCAL="/Users/koller/Library/ApplicationSupport/typst/packages/local"
mkdir -p "$LOCAL"

cp -r release/preview/tracl "$LOCAL"
