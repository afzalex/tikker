#!/bin/bash
###


outputDir=output
alreadyProcessedThreshold=50

source .env

mkdir -p "${outputDir}/downloads"
downloaded=`ls -l1 "${outputDir}/downloads"`

newlyProcessedCounter=0
alreadyProcessedCounter=0
tail -r "${outputDir}/list.dat" |  
while read line
do 
    json=`cat ${outputDir}/$line/data.json`
    filename="`jq -r '.media.user.username' <<< $json`_`jq -r '.media.id' <<< $json`.mp4"
    if ! grep -q "$filename$" <<< "${downloaded}"
    then
        echo "Processed $newlyProcessedCounter new entries and found $alreadyProcessedCounter already processed files | Processing $filename"
        url=`jq -r '.media.video_versions[0].url' <<< $json`
        echo "$url"
        wget "$url" -O "${outputDir}/downloads/$filename"
        newlyProcessedCounter=$(($newlyProcessedCounter + 1))
    else
        alreadyProcessedCounter=$(($alreadyProcessedCounter + 1))
        echo "Processed $newlyProcessedCounter new entries and found $alreadyProcessedCounter already processed files : $filename"
        if [[ $alreadyProcessedCounter -gt $alreadyProcessedThreshold ]]
        then
            echo "Processed $newlyProcessedCounter new entries and found $alreadyProcessedCounter already processed files"
            break
        fi
    fi
done


