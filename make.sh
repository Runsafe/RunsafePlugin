#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
	echo "Usage: ./make.sh <PluginName> <pluginname>"
	exit 1
fi

plugin=$1
package=$2
if [ -d "../${plugin}" ]; then
	echo "The ${plugin} folder already exists!";
	exit 1
fi
find -type d -exec mkdir "../${plugin}/{}" \;
cp -a .gitignore .idea META-INF src ../$plugin
cp PluginName.iml ../$plugin/$plugin.iml
cd ../$plugin/.idea
for file in `find -type f`; do
	mv $file "${file}~"
	sed -e "s/PluginName/${plugin}/" -e "s/plugin_name/${package}/" "${file}~" > $file
done
cd ../src
for file in `find -type f`; do
	mv $file "${file}~"
	sed -e "s/PluginName/${plugin}/" -e "s/plugin_name/${package}/" "${file}~" > $file
done
cd ..
find -name *~ | xargs rm
git init
git add -A
git commit -m "Initialized new plugin $plugin from template"