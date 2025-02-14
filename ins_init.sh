# sudo nano /etc/systemd/system/initverse-miner.service

sudo apt update
sudo apt upgrade
apt install nano

mkdir -p $HOME/initverse
cd $HOME/initverse
wget https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
chmod +x iniminer-linux-x64
cd

echo -e "EVM wallet:"
read WALLET
echo -e "miner name:"
read NODE_NAME

sudo bash -c "cat <<EOT > /etc/systemd/system/initverse-miner.service
[Unit]
Description=Initverse Miner Service
After=network.target

[Service]
ExecStart=/root/initverse/iniminer-linux-x64 --pool stratum+tcp://$WALLET.$NODE_NAME@pool-b.yatespool.com:32488 --cpu-devices 1 --cpu-devices 2 --cpu-devices 3 --cpu-devices 4 
#ExecStart=/root/initverse/iniminer-linux-x64 --pool stratum+tcp://$WALLET.$NODE_NAME@pool-a.yatespool.com:31588 --cpu-devices 1 --cpu-devices 2 --cpu-devices 3 --cpu-devices 4 --cpu-devices 5
WorkingDirectory=/root/initverse
Restart=always
User=root
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
EOT"

sudo systemctl daemon-reload
sudo systemctl enable initverse-miner
sudo systemctl start initverse-miner
sudo systemctl status initverse-miner


