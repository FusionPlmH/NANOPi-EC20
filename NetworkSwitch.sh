#!/bin/bash
check_current_interface_1=$(route | grep '^default' | grep -o '[^ ]*$')
check_current_interface_2=$(route | awk '/^default/{print $NF}')
google_wired=$(ping -I eth0 -c 3 8.8.8.8 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
ali_wired=$(ping -I eth0 -c 3 223.5.5.5 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
cloudflare_wired=$(ping -I eth0 -c 3 1.1.1.1 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
google_modem=$(ping -I "ppp0" -c 3 8.8.8.8 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
ali_modem=$(ping -I eth0 -c 3 223.5.5.5 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
cloudflare_modem=$(ping -I "ppp0" -c 3 1.1.1.1 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)

# Wired Mobile Network Connection Checking
if [[ $check_current_interface_1 == "eth0" || $check_current_interface_2 == "eth0" ]]; then
  echo "Wired Network Detected" >> /etc/networkswitch.log
  if [[ $google_wired == 3 || $ali_wired == 3 || $cloudflare_wired == 3 ]]; then
	echo "Wired External Network connect Successfully , auto check it again later" >> /etc/networkswitch.log
  else
    	echo "External Network Unreachable ， Checking Mobile Network Status" >> /etc/networkswitch.log
     	if [[ $check_current_interface_1 == "ppp0" || $check_current_interface_2 == "ppp0" ]]; then
  		echo "Mobile Network Detected" >> /etc/networkswitch.log
  		if [[ $google_modem == 3 || $ali_modem == 3 || $cloudflare_modem == 3 ]]; then
			echo "Mobile External Network Connect Successfully , Check Wired Network" >> /etc/networkswitch.log
  			if [[ $google_wired == 3 || $ali_wired == 3 || $cloudflare_wired == 3 ]]; then
    				echo "Wired External Network Connected , Switching Back" >> /etc/networkswitch.log
				ifmetric eth0 0
				ifmetric ppp0 100
  			else
     				ifmetric ppp0 0
       				ifmetric eth0 100
   			fi
  		fi
	fi
  fi
fi
echo "Complete Time: $(date) , will run this script 5 second later " >> /etc/networkswitch.log
sleep 5s
systemctl restart NetworkSwitch
