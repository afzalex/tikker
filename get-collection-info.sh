#!/bin/bash

outputDir=output
collectionId=fetchfromenv
alreadyProcessedThreshold=100 # already processed files found consicutively
maxId=
moreAvailable=true

source .env

if ! [[ -f 'headers.txt' ]]; then
    echo header file not found
    exit
fi

mkdir -p "${outputDir}"
touch "${outputDir}/list.dat"
newlyProcessedCounter=0
alreadyProcessedCounter=0 # already processed files found consicutively
while [[ $moreAvailable == 'true' ]]
do
    moreAvailable=false
    query="https://i.instagram.com/api/v1/feed/collection/${collectionId}/posts/?max_id=$maxId";
    echo "Processed $newlyProcessedCounter new and $alreadyProcessedCounter already processed entries till max_id $maxId"
    curl -sH @headers.txt "${query}" | jq > .output.json

    echo "$( wc -c .output.json )"
    
    if [[ $(cat .output.json | jq -r '.status' ) != 'ok' ]]; then 
        echo "Failed"; 
        exit 1
    fi
    exit
    for row in $(cat .output.json | jq -r '.items[] | @base64' )
    do 
        json=`echo $row | base64 --decode`
        idval=`echo $json | jq -r '.media.id'`; 
        if cat "${outputDir}/list.dat" | grep "${idval}" > /dev/null
        then
            alreadyProcessedCounter=$(($alreadyProcessedCounter + 1))
            if [[ $alreadyProcessedCounter -gt $alreadyProcessedThreshold ]]
            then
                break 2
            else 
                continue
            fi
        else 
            alreadyProcessedCounter=0
        fi
        mkdir -p "${outputDir}/$idval"
        echo "$json" > "${outputDir}/${idval}/data.json"
        echo "${idval}" >> "${outputDir}/list.dat"
        echo "Processing ${outputDir}/${idval}/data.json"
        newlyProcessedCounter=$(($newlyProcessedCounter + 1))
    done
    maxId=$(cat .output.json | jq -r '.next_max_id')
    moreAvailable=$(cat .output.json | jq -r '.more_available')
done

echo "Processed $newlyProcessedCounter new entries and found $alreadyProcessedCounter already processed entries consecutively"