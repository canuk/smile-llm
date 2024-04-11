# Set up a Wireless Access Point so that we can get to the SMILELLM from WiFi
sudo apt --yes --allow-unauthenticated install dnsmasq hostapd

sudo DEBIAN_FRONTEND=noninteractive apt --yes --allow-unauthenticated install netfilter-persistent iptables-persistent

# Add this text to /etc/dhcpcd.conf
sudo bash -c 'echo "interface wlan0" >> /etc/dhcpcd.conf'
sudo bash -c 'echo "    static ip_address=192.168.12.1/24" >> /etc/dhcpcd.conf'
sudo bash -c 'echo "    nohook resolv.conf, wpa_supplicant" >> /etc/dhcpcd.conf'

# Copy /setup_files/hotspot.conf to /etc/dnsmasq.d/hotspot.conf
sudo cp ~/hotspot.conf /etc/dnsmasq.d/hotspot.conf

sudo rfkill unblock wlan
# Add this text to /etc/default/dnsmasq
sudo bash -c 'echo "# do not overwrite /etc/resolv.conf so that local DNS still goes through" >> /etc/default/dnsmasq'
sudo bash -c 'echo "DNSMASQ_EXCEPT=lo" >> /etc/default/dnsmasq'

# Copy hostapd.conf to /etc/hostapd/hostapd.conf
sudo cp ~/hostapd.conf /etc/hostapd/hostapd.conf

# then update the SSID using the MAC Address suffix
echo "update SSID with LAST_FOUR_MAC_ADDRESS"

LAST_FOUR_MAC_ADDRESS="$(ip addr | grep link/ether | awk '{print $2}' | tail -1  | sed s/://g | tr '[:lower:]' '[:upper:]' | tail -c 5)"
ETH0_NAME="$(ip addr | grep 2: | awk '{print $2}' | tail -1  | sed s/://g)"

echo "new SSID: $LAST_FOUR_MAC_ADDRESS"
sudo sed -i 's/SMILE/SMILELLM_'"$LAST_FOUR_MAC_ADDRESS"'/' /etc/hostapd/hostapd.conf

# Add this text to the bottom of /etc/default/hostapd
sudo bash -c "echo 'DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"' >> /etc/default/hostapd"

# Copy /setup_files/routed-ap.conf to /etc/sysctl.d/routed-ap.conf
sudo cp ~/routed-ap.conf /etc/sysctl.d/routed-ap.conf

# Allow users to use the internet, if the ethernet cable is connected to a source with internet
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo netfilter-persistent save

# Now restart and enable all the goodies
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd
sudo systemctl restart dnsmasq