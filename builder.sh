#!/bin/bash

source settings.sh

read -p "Run build (n) ? " input
if [[ $input == "y" ]]
then 
    npm run build --prefix "${site_loc}"
fi

read -p "Tar (n) ? " input
if [[ $input == "y" ]]
then 
    tar -cvf build.tar ${site_loc}/build
fi

read -p "Serve (n) ? " input
if [[ $input == "y" ]]
then 
    npx serve
fi

read -p "Copy (n) ? " input
if [[ $input == "y" ]]
then 
    scp build.tar afzal@raspi.home:./
fi


