#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
	echo "Usage: ./make.sh <PluginName> <pluginname>"
	exit 1
fi

login=$(cat github-user)

if [ -z $login ]; then
	echo "Please put username:password in a file github-user"
	exit 1
fi

./deploy.sh $1 $2
if [ $? -gt 0 ]; then
	exit $?
fi

./setup.sh $1 $2
exit $?
