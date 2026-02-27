#!/bin/bash
git clone https://git.mc8051.de/nitro/arcturus-morningstar-default-swf-pack.git assets/swf/ && \
git clone https://git.mc8051.de/nitro/default-assets.git assets/assets/ && \
wget -O room.nitro.zip https://git.mc8051.de/attachments/e948e603-d0ea-4948-b313-e8290a1c4bc9 && \
unzip -o room.nitro.zip -d assets/assets/bundled/generic && \
docker compose up db -d