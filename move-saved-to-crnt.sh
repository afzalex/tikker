#!/bin/bash

crnt_collection_id=fetchfromenv
auto_collection_id=fetchfromenv
xplr_collection_id=fetchfromenv
alreadyProcessedThreshold=20 # already processed files found consicutively
maxId=
moreAvailable=true

mkdir -p .tmp
cat 'headers.txt.tpl' | envsubst > ".tmp/headers.txt"
cat 'env-setup.sh.tpl' | envsubst > '.tmp/env-setup.sh'

source .tmp/env-setup.sh

mkdir -p "fzbot/collectionsToUserId"
newlyProcessedCounter=0
alreadyProcessedCounter=0 # already processed files found consicutively

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function collection_name {
    name="na"
    case "${1}" in
    "${crnt_collection_id}" )
        name="crnt"
        ;;
    "${auto_collection_id}")
        name="auto"
        ;;
    "${xplr_collection_id}")
        name="xplr"
        ;;
    esac
    printf %s "${name}"
}

processStartTime=$(date +%s)
while [[ $moreAvailable == 'true' ]]
do
    moreAvailable=false
    query="https://www.instagram.com/api/v1/feed/saved/posts/?max_id=$maxId"
    echo "Processed $newlyProcessedCounter new and $alreadyProcessedCounter already processed entries till max_id $maxId"
    # curl -sH @.tmp/headers.txt "${query}"
    curl -v -sH @.tmp/headers.txt "${query}" > .output.savetocrnt.json
    if [[ $(cat .output.savetocrnt.json | jq -r '.status') -ne 'ok' ]]; then
        echo "Failed..."
        exit 1
    fi
    # read -p "Continue : " yn; if [ "$yn" == "n" ]; then echo exit; fi
    for row in $(cat .output.savetocrnt.json | jq -r '.items[].media | @base64' )
    do 
        if [[ $(( $(date +%s) - ${processStartTime} )) -lt ${moverate} ]]; then
            echo -n "Waiting ";
            while [[ $(( $(date +%s) - ${processStartTime} )) -lt ${moverate} ]]; do 
                echo -n "."
                sleep 0.25
            done
            echo "#"
            echo "Waiting released at $(( $(date +%s) - ${processStartTime} )) / ${moverate} "
        fi
        processStartTime=$(date +%s)
        json=`echo $row | base64 --decode`
        idval=`echo $json | jq -r '.pk'`; 
        feed_is_following="`echo "$json" | jq '.user.friendship_status.following'`"
        feed_username="`echo "$json" | jq -r '.user.username'`"
        feed_caption="`echo "$json" | jq -r '.caption.text'`"
        feed_caption="${feed_caption:0:20}"
        feed_caption="${feed_caption//[$'\t\r\n']}"
        feed_saved_collection_ids="`echo "$json" | jq '.saved_collection_ids'`"
        # is_present_in_crnt=`echo "$feed_saved_collection_ids" | grep "$crnt_collection_id"`
        is_present_in_crnt="${feed_saved_collection_ids##*$crnt_collection_id*}"
        # echo "Is following $feed_username : $feed_is_following | crnt:${is_present_in_crnt} | present in $feed_saved_collection_ids"
        echo ">>> ${idval} | by:${feed_username} | following:${feed_is_following} | cap:'${feed_caption}' | collections:${feed_saved_collection_ids}"
        
        isalreadyprocessed=false
        target_callection_ids=()
        if [ "$feed_is_following" == "false" ]; then                                        # if user is not followed
            if [ "${feed_saved_collection_ids##*$explr_collection_id*}" ]; then
                echo "going to add to explr ($xplr_collection_id)"
                target_callection_ids+=("${xplr_collection_id}")
            else 
                isalreadyprocessed=true
            fi
        fi
        if [ "${feed_saved_collection_ids##*$crnt_collection_id*}" ]; then                  # if not stored in crnt then saveit
            echo "going to add to crnt ($crnt_collection_id)"
            target_callection_ids+=("${crnt_collection_id}")
        else 
            isalreadyprocessed=true
        fi
        if [ "${feed_saved_collection_ids##*$auto_collection_id*}" ]; then                  # if not stored in auto then saveit
            echo "going to add to auto ($auto_collection_id)"
            target_callection_ids+=("${auto_collection_id}")
        else 
            isalreadyprocessed=true
        fi

        if [ "${isalreadyprocessed}" == "true" ]; then
            echo "already processed @$alreadyProcessedCounter"
            alreadyProcessedCounter=$(($alreadyProcessedCounter + 1))
            if [[ $alreadyProcessedCounter -gt $alreadyProcessedThreshold ]]
            then
                echo already processed threshold encountered
                break 2
            else 
                # read -p "Continue : " yn; if [ "$yn" == "n" ]; then echo exit; fi
                continue
            fi
        else
            alreadyProcessedCounter=0
        fi

        echo "target collections ${target_callection_ids[@]}"
        echo "Initiating addition"
        # read -p "Continue : " yn; if [ "$yn" == "n" ]; then echo exit; fi
        target_callection_ids_with_quotes=()
        for i in "${target_callection_ids[@]}"; do
            addition_output=$(
                    curl -sH @.tmp/headers.txt "https://www.instagram.com/api/v1/collections/${i}/edit/" \
                    --data-raw "added_media_ids=%5B%22${idval}%22%5D&removed_media_ids=%5B%5D" \
                    --compressed 
                )
            output_status=$(echo "$addition_output" | jq -r '.status')
            if [ "ok" == "$output_status" ]; then
                echo "Added to $(collection_name $i)"
            else 
                echo "Failed to add to $i : $output_status"
                echo "$addition_output" | jq
            fi
        done
        newlyProcessedCounter=$(($newlyProcessedCounter + 1))
        # read -p "Continue : " yn; if [ "$yn" == "n" ]; then echo exit; fi
    done
    maxId=$(cat .output.savetocrnt.json | jq -r '.next_max_id')
    moreAvailable=$(cat .output.savetocrnt.json | jq -r '.more_available')
done

echo "Processed $newlyProcessedCounter new entries and found $alreadyProcessedCounter already processed entries consecutively"
