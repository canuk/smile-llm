# README

## About this Project
This project is for using a Raspberry Pi to power a local instance of a Large Language Model (Phi-2) to run a website that will evaluate questions on a level from one to five, along Bloom's Taxonomy, with one being a very simple question and five being a question that requires higher order thinking skills.

### Running Locally
If you want to run this on your own computer, the steps are almost the same, you just probably don't want to create system services to background run the llama.cpp server and the soul server, however you'll need both llama.cpp and soul running at the same time, and need to make sure the paths are correct in index.html, question_log.html and data.html

### Install Software on Raspberry Pi
Install required packages
```
sudo apt update && sudo apt upgrade && sudo apt install git
sudo apt install python3-torch python3-numpy python3-sentencepiece
sudo apt install g++ build-essential
sudo apt install sqlite3
sudo apt remove apache2
sudo apt install nginx
sudo apt install npm
sudo npm install -g soul-cli
```
### Download and compile llama.cpp
```
cd ~
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp/
make
```


#### Raspberry Pi Setup & Development Notes
Install SQLite
`sudo apt install sqlite3`

create the database
`sudo sqlite3 smilellm.db`

create the tables
`sudo sqlite3 smilellm.db < smilellm.sql`

Create a small [SQLite REST server](https://github.com/thevahidal/soul) to save questions and responses.

Make sure npm is installed
`sudo apt install npm`

Install soul using npm
`sudo npm install -g soul-cli`


We're going to run it on port 8081 (next to the LLM on port 8080)
`sudo soul -d /var/www/html/smilellm.db -p 8081`

add this to /etc/nginx/sites-enabled:
```
        location /database {
                proxy_pass http://127.0.0.1:8081/api;
        }
```
copy `soul.service` file to load the soul server on boot/reboot
`cp soul.service /lib/systemd/system/`

Now enable the service and start it:
`sudo systemctl enable soul.service`
`sudo systemctl start soul.service`

then check to make sure it is running:
`sudo systemctl status soul.service.`

make sure you change the Soul API urls in index.html and question_log.html
For example, instead of the API url being `localhost:8000/api`, it is now just `/database` because of the nginx location directive we set above.

Now to make our Raspberry Pi into a Router/AP
https://vaibhavji.medium.com/turn-your-raspberrypi-into-a-wifi-router-5ade510601de
```
sudo apt-get update
sudo apt-get install dnsmasq hostapd

There was a bunch of new stuff on Bookworm (newest RPi OS) where the access point didn't work out of the box. The NetworkManager kept trying to take control so I had to stop network manager, statically assign an IP address to wlan0, it was a whole thing.


To Test Locally on My Mac
Load 3(!!) Servers:
```
soul -d ~/projects/smilellm/smilellm.db -p 8081
./server -m models/phi-2.Q5_K_M.gguf -c 2048 --path ~/projects/smilellm
libretranslate
```
