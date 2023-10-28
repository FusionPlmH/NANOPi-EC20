sudo -s
sed -i -e '# Startup 4G command' /etc/rc.local
sed -i -e 'sleep 10s' /etc/rc.local
sed -i -e 'sudo pppd call quectel-pppd' /etc/rc.local
wget --no-check-certificate -t 1 -T 10 -q -P /etc/ppp/peers https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/quectel-chat-connect
wget --no-check-certificate -t 1 -T 10 -q -P /etc/ppp/peers https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/quectel-pppd
wget --no-check-certificate -t 1 -T 10 -q -P /etc/ppp/peers https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/quectel-chat-disconnect
sudo chmod a+x /etc/ppp/peers/quectel-chat-connect
sudo chmod a+x /etc/ppp/peers/quectel-pppd
sudo chmod a+x /etc/ppp/peers/quectel-chat-disconnect
systemctl enable rc-local
reboot
