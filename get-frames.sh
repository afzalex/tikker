#!/bin/bash

source .env
inputdir="$outputDir/downloads/"
outputdir="$outputDir/frames/at500/"
force=$1

mkdir -p "$outputdir"
list="`ls ${inputdir} | grep -E '.mp4$'`"
entrycount=`echo "$list" | wc -l`
counter=0
corruptEntriesReportFile="$outputDir/corrupt_entries_report.txt"
rm -f "$corrupt_entries_report"
# echo "$list" | 
while read -u3 line
do 
    counter=$(( $counter + 1 ))
    progress=`echo $(( $counter * 100 / $entrycount ))`
    if [ -f "${outputdir}${line}_frame01.jpeg" ]
    then
        echo "skipping $line : $progress%"
        continue
    fi

    echo "Processing ${inputdir}${line} : $progress%"

    # echo ffmpeg  -nostdin -v error -i "${inputdir}${line}" -frames:v 10 -r 0.5 "${outputdir}${line}_frame%02d.jpeg"
    ffmpeg  -nostdin -v error -i "${inputdir}${line}" -frames:v 10 -r 0.5 "${outputdir}${line}_frame%02d.jpeg" < /dev/null
    status=$?
    if [[ "$status" != 0 ]]
    then 
        echo "Error occured [$status]. "
        echo "${line}" >> "$corruptEntriesReportFile"
        if [[ $1 == "f" ]]
        then
            continue
        fi

        read -p "Want to continue (n) ? : " errorprompt
        echo $errorprompt
        if [[ $errorprompt == 'n' ]]
        then 
            break
        fi
    fi
done 3<<< "$list"
