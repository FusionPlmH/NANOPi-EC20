# NANOPi-EC20

**Please Edit quectel-chat-connect , line 11 "OK AT+CGDCONT=1,"IP","internet",,0,0"  before you go. My APN setting is :internet . **

Setup EC20 For Connect , script will auto reboot ：</br>
```
sudo wget --no-check-certificate -t 1 -T 10 -q https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/ec20setup.sh && bash ./ec20setup.sh
```

Setup NetworkSwitch for failover ：</br>
1. Install Crontab : ```sudo apt install cron```
2. Download Script : ```wget --no-check-certificate -t 1 -T 10 -q -P /etc https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/NetworkSwitch.sh && chmod a+x /etc/NetworkSwitch.sh```
3. Setup Crontab : ```crontab -e```
4. Add the following into crontab: ```* * * * * /etc/NetworkSwitch.sh```
5. exit and save and run : ```/etc/init.d/cron restart```

   
Reference link :

https://wiki.friendlyelec.com/wiki/index.php/How_to_use_4G_Module_on_Debian
