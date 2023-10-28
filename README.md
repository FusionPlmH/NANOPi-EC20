# NANOPi-EC20

**Please Edit quectel-chat-connect , line 11 "OK AT+CGDCONT=1,"IP","internet",,0,0"  before you go. My APN setting is :internet . **

Setup EC20 For Connect ：</br>
```
sudo wget --no-check-certificate -t 1 -T 10 -q https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/ec20setup.sh && bash ./ec20setup.sh
```

Setup NetworkSwitch for failover ：</br>
```
sudo wget --no-check-certificate -t 1 -T 10 -q https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/failoversetup.sh && bash ./failoversetup.sh
```

Reference link :

https://wiki.friendlyelec.com/wiki/index.php/How_to_use_4G_Module_on_Debian
