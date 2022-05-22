#!/usr/bin/env bash

# docker repository
REPO_NAME=noctuary/phpmyadmin

# script parameters
SOURCE_DIR=$1
DEST_DIR=$2
PMA_VERSION=$3

echo "[info] size: `du -sh $SOURCE_DIR`"

# Copy source to dest
rm -rf $DEST_DIR
mkdir -p $DEST_DIR
cp -a $SOURCE_DIR/. $DEST_DIR/

# Generate secret
randomSecret=$(openssl rand -base64 32)
sed "s@secretToChange@$randomSecret@" config/config.secret.tpl > config/config.secret.inc.php

# Remove unwanted folders
FoldersToRemove=(
    "doc"
    "examples"
    "setup"
    "js/src"
    # additionnal themes
    "themes/bootstrap"
    "themes/metro"
    "themes/original"
    # TCPDF lib (export shema as PDF feature)
    "vendor/tecnickcom"
    # GIS visualisation
    "js/vendor/openlayers"
)
for delFolder in ${FoldersToRemove[@]}; do
    rm -rf $DEST_DIR/$delFolder
done

# Remove unwanted files
FilesToRemove=(
    "composer.*"
    "installed.json"
    "yarn.lock"
    "changelog.*"
    "changelog"
    "readme"
    "readme.*"
)
for delFile in ${FilesToRemove[@]}; do
    find $DEST_DIR -type f -iname $delFile -delete
done
find $DEST_DIR -type f -name '*.md' -delete

echo "[info] size: `du -sh $DEST_DIR`"

# Build docker image
docker build -t $REPO_NAME:latest -t $REPO_NAME:$PMA_VERSION .
