#!/bin/bash

source ./settings.sh

if [[ ${DOFETCH} == 1 ]]
then

    # download new data into jsons
    ./get-collection-info.sh 
    if [ "$?" != "0" ]; then exit 1; fi

    # download videos
    ./downloader.sh

    # create frames 
    ./get-frames.sh f

    # update new frames to site
    ./updatesiteframes.sh
fi

if [[ ${DOBUILD} == 1 ]]; then
    pushd .
    cd ${site_loc}
    npm install
    npm run build
    popd
fi

if [[ ${DOSERVE} == 1 ]]; then
    echo y | npx serve
fi
