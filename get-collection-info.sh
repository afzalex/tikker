#!/bin/bash

outputDir=output
collectionId=17909366908042779
maxId=
moreAvailable=true

source .env

if ! [[ -f 'headers.txt' ]]; then
    echo header file not found
    exit
fi

mkdir -p "${outputDir}"
touch "${outputDir}/list.dat"
while [[ $moreAvailable == 'true' ]]
do
    moreAvailable=false
    query="https://i.instagram.com/api/v1/feed/collection/${collectionId}/posts/?max_id=$maxId";
    echo "$query"
    curl -sH @headers.txt "${query}" | gunzip | jq > .output.json

    for row in $(cat .output.json | jq -r '.items[] | @base64' )
    do 
        json=`echo $row | base64 --decode`
        idval=`echo $json | jq -r '.media.id'`; 
        if cat "${outputDir}/list.dat" | grep "${idval}"
        then
            exit
        fi
        mkdir -p "${outputDir}/$idval"
        echo "$json" > "${outputDir}/${idval}/data.json"
        echo "${idval}" >> "${outputDir}/list.dat"
        echo "${outputDir}/${idval}/data.json"
    done

    maxId=$(cat .output.json | jq -r '.next_max_id')
    moreAvailable=$(cat .output.json | jq -r '.more_available')
done
