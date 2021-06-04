#!/bin/bash

outputDir=output

source .env

mkdir -p "${outputDir}/downloads"
downloaded=`ls -l1 "${outputDir}/downloads"`
tail -r "${outputDir}/list.dat" |
while read line
do 
    json=`cat output/general/$line/data.json`
    filename="`jq -r '.media.user.username' <<< $json`_`jq -r '.media.id' <<< $json`.mp4"
    if ! grep -q "$filename" <<< "${downloaded}"
    then
        url=`jq -r '.media.video_versions[0].url' <<< $json`
        wget "$url" -O "${outputDir}/downloads/$filename"
    else
        exit
    fi
done