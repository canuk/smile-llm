#!/usr/bin/env bash

echo "update SSID with LAST_FOUR_MAC_ADDRESS"

LAST_FOUR_MAC_ADDRESS="$(ip addr | grep link/ether | awk '{print $2}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5)"
ETH0_NAME="$(ip addr | grep 2: | awk '{print $2}' | tail -1  | sed s/://g)"

echo "new SSID: SMILELLM_$LAST_FOUR_MAC_ADDRESS"
sudo sed -i 's/SMILELLM_....$/SMILELLM_'"$LAST_FOUR_MAC_ADDRESS"'/' /etc/hostapd/hostapd.conf
sudo systemctl restart hostapd.service