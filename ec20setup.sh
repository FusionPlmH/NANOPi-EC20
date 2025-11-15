wget --no-check-certificate -t 1 -T 10 -q -P /etc/ppp/peers https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/quectel-chat-connect
wget --no-check-certificate -t 1 -T 10 -q -P /etc/ppp/peers https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/quectel-pppd
wget --no-check-certificate -t 1 -T 10 -q -P /etc/ppp/peers https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/quectel-chat-disconnect
wget --no-check-certificate -t 1 -T 10 -q -P /etc/systemd/system https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/ec20-lte.service
sudo chmod a+x /etc/ppp/peers/quectel-chat-connect
sudo chmod a+x /etc/ppp/peers/quectel-pppd
sudo chmod a+x /etc/ppp/peers/quectel-chat-disconnect
systemctl enable ec20-lte.service
reboot
