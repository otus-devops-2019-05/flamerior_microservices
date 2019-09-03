[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
Environment="DATABASE_URL=${db_ip}:27017"
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
