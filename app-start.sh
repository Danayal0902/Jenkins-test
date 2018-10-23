#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# update apt-get
apt-get update -y
# install node js
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
# update npm
npm install npm --global
# clone the toy app
git clone "https://${github_user}:${github_password}@github.com/cloudreach/deploy-toy.git"
cd deploy-toy/react-toy
# install the app
npm install
# run the app
nohup npm start &