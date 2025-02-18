#! /bin/bash

VERSION=$1

if [ -z "$VERSION" ];
then
    echo "You need to specify a version number."
    exit 1
fi


RELEASE_DIR=release/preview/acl/$VERSION



# Put together release

rm -rf $RELEASE_DIR
mkdir -p $RELEASE_DIR

cp acl.typ $RELEASE_DIR/lib.typ
cp README.md $RELEASE_DIR/
cp LICENSE $RELEASE_DIR/
cp association-for-computational-linguistics-blinky.csl $RELEASE_DIR/

# replace version in typst.toml
sed "s/VERSION/$VERSION/g" typst-template.toml > $RELEASE_DIR/typst.toml

echo "Package is ready for release in $RELEASE_DIR."