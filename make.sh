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

plugin=$1
package=$2
if [ -d "../${plugin}" ]; then
	echo "The ${plugin} folder already exists!";
	exit 1
fi
find -type d -exec mkdir "../${plugin}/{}" \;
cp -a .gitignore .idea META-INF src ../$plugin
sed -e "s/PluginName/${plugin}/" -e "s/plugin_name/${package}/" ant.xml > ../$plugin/ant.xml
cp PluginName.iml ../$plugin/$plugin.iml
cd ../$plugin/.idea
(cd artifacts; mv PluginName.xml "${plugin}.xml")
echo $plugin > .name
for file in `find -type f`; do
	mv $file "${file}~"
	sed -e "s/PluginName/${plugin}/" -e "s/plugin_name/${package}/" "${file}~" > $file
done
cd ../src
(cd no/runsafe; mv plugin_name $package)
for file in `find -type f`; do
	mv $file "${file}~"
	target=$(echo $file | sed -e "s/PluginName/${plugin}/" -e "s/plugin_name/${package}/")
	sed -e "s/PluginName/${plugin}/" -e "s/plugin_name/${package}/" "${file}~" > $target
done
cd ..
find -name *~ | xargs rm
git init
git add -A
git commit -m "Initialized new plugin $plugin from template"
git remote add origin "git@github.com:Runsafe/${plugin}.git"
git push -u origin master
curl -i -u "$login" -d '{ "name": "'$plugin'", "auto_init": false }' https://api.github.com/orgs/runsafe/repos
ssh jenkins@10.0.30.3 "./create.sh $plugin"
