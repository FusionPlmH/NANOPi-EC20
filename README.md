# NANOPi-EC20

**Please Edit quectel-chat-connect , line 11 "OK AT+CGDCONT=1,"IP","internet",,0,0"  before you go. My APN setting is :internet . **

Setup EC20 For Connect , script will auto reboot ：</br>
```
sudo wget --no-check-certificate -t 1 -T 10 -q https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/ec20setup.sh && bash ./ec20setup.sh
```
# Method 1 ：
Setup failover network(In simple) ：
1. Install ifmetric : ```sudo apt install ifmetric ```
2. Add default route for EC20 Network : ```route add default ppp0```
3. Set Metric to Eth0 priority traffic to go through this :```ifmetric eth0 0```
4. Set Metric to ppp0 for failover :```ifmetric ppp0 100```

Once the Eth0 has been reconnected , we should set back the priority :```ifmetric eth0 0```


# Method 2：
Unstable NetworkSwitch for failover(In Advance, under testing) ：</br>
1. Install Crontab : ```sudo apt install cron ```
2. Download Script : ```wget --no-check-certificate -t 1 -T 10 -q -P /etc https://raw.githubusercontent.com/FusionPlmH/NANOPi-EC20/main/NetworkSwitch.sh && chmod a+x /etc/NetworkSwitch.sh```
3. Setup Crontab : ```crontab -e```
4. Add the following into crontab: ```* * * * * /bin/bash /etc/NetworkSwitch.sh ```
5. exit and save and run : ```service cron restart```
6. Check Script Running log :  ```cat /etc/networkswitch.log ```

   
Reference link :

https://wiki.friendlyelec.com/wiki/index.php/How_to_use_4G_Module_on_Debian
