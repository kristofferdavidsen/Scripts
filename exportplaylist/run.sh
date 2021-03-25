#!/bin/bash
read -p "Type name of playlist: " plname
echo "Exporting playlist..."
if [ $(osascript ~/git/applescripts/export_playlist.scpt $plname) == 0 ];
then
	echo "Export successful!"
else
	echo "Export not successful, please check your input!"
fi
