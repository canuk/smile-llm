### README

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
