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
if [[ $check_current_interface_1 -eq "eth0" || $check_current_interface_2 -eq "eth0" ]] ; then
	if [[ $google_wired -eq 3 || $ali_wired -eq 3 || $cloudflare_wired -eq 3 ]]; then
		echo "Wired External Network connect Successfully and in use , auto check it again later" >> /etc/networkswitch.log
 		ifmetric eth0 0
		ifmetric ppp0 100
  	fi
else
	if [[ $google_modem -eq 3 || $ali_modem -eq 3 || $cloudflare_modem -eq 3 ]] ; then
 		if [[ $google_wired -ne 3 | $ali_wired -ne 3 | $cloudflare_wired -ne 3 ]]; then
       			echo "Mobile External Network connect Successfully and in use , Fix Wired Network Connection ASAP! " >> /etc/networkswitch.log
	   		ifmetric eth0 100
			ifmetric ppp0 0
   		fi
	fi
fi
echo "Complete Time: $(date) , will run this script 5 second later " >> /etc/networkswitch.log
sleep 2s
systemctl restart NetworkSwitch
