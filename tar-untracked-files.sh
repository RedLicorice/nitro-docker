#!/bin/bash

TAG=$(date +%Y%m%dT%H%M%S)

tar czvf ./config_$TAG.tgz \
    ./.env \
    ./.cms.env \
    ./nitro/renderer-config.json \
    ./nitro/ui-config.json \
    ./assets/roomitemtypes.json \
    ./assets/wallitemtypes.json
