sudo ufw default deny incoming
ufw default allow outgoing

ufw allow ssh

ufw enable

ufw allow from 15.15.15.51 to any port 22
