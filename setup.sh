#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
	echo "Usage: ./setup.sh <PluginName> <pluginname>"
	exit 1
fi

login=$(cat github-user)

if [ -z $login ]; then
	echo "Please put username:password in a file github-user"
	exit 1
fi

plugin=$1
package=$2
cd ../$plugin
curl -i -u "$login" -d '{ "name": "'$plugin'", "auto_init": false }' https://api.github.com/orgs/runsafe/repos
git remote add origin "git@github.com:Runsafe/${plugin}.git"
git push -u origin master
ssh jenkins@10.0.30.3 "./create.sh $plugin"
