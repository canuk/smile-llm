### README

#### Development Notes
Install SQLite
`sudo apt install sqlite3`

`sqlite3 smilellm.db < smilellm.sql`

Create a small SQLite REST server to save questions and responses
https://github.com/thevahidal/soul

`npm install -g soul-cli`

We're going to run it on port 8081 (next to the LLM on port 8080)
`sudo soul -d /var/www/html/smilellm.db -p 8081`

add this to /etc/nginx/sites-enabled:
```
        location /database {
                proxy_pass http://127.0.0.1:8081/api;
        }
```
created a new soul.service file to load the soul server on boot/reboot

