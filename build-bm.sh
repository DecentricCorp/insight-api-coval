#!/bin/sh
    DIR="$( cd "$( dirname "$0" )" && pwd )"
    if [ -n "$1" ]; then

    #----- Build on Bluemix
    cf ic build -t registry.ng.bluemix.net/$1/coval-explorer . --no-cache

    #----- Create instance on Bluemix
    echo "Starting Bluemix Volume handling"
    fs=`cf ic volume fs-list | grep legacyledger`
    if [ -n "$fs" ]; then
        echo "found fs legacyledger"
    else 
        echo "didn't find fs legacyledger"
        fscreate=`cf ic volume fs-create legacyledger 20 4`
        echo $fscreate
        ready=`cf ic volume fs-inspect legacyledger | grep READY`
        while [ -z "$ready" ]
        do
            echo $ready "fs being built. Pausing 5s"
            sleep 5
            ready=`cf ic volume fs-inspect legacyledger | grep READY`
        done
            echo "complete"
    fi

    share=`cf ic volume list | grep legacyledgershare`
    if [ -n "$share" ]; then
        echo "found volume legacyledgershare"
    else 
        echo "didn't find volume legacyledgershare"
        create=`cf ic volume create legacyledgershare legacyledger`
        echo $create
    fi
    #cf ic run -p 3027:3027 -m 2048 --name insite-api-coval registry.ng.bluemix.net/$1/insight-api-coval
    bluemix ic group-create --name coval-explorer \
                --publish 3027 --memory 2048 --auto \
                --hostname coval-explorer \
                --domain mybluemix.net \
                --min 1 --max 2 --desired 1 \
                --volume legacyledgershare:/root/.coval-insight \
                registry.ng.bluemix.net/$1/coval-explorer
else
    echo "Please provide a name for this deployment"
fi