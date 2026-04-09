#!/bin/bash

MODEL=$(cat /sys/class/dmi/id/product_version)

if echo "$MODEL" | grep -qi thinkpad; then
    KBMODEL="thinkpad"
else
    KBMODEL="pc105"
fi

sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br $KBMODEL abnt2

echo "Modelo detectado: $KBMODEL"
