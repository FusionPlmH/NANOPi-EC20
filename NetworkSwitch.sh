#!/bin/bash
check_current_interface_1=$(route | grep '^default' | grep -o '[^ ]*$')
check_current_interface_2=$(route | awk '/^default/{print $NF}')
google_wired=$(ping -I eth0 -c 3 8.8.8.8 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
ali_wired=$(ping -I eth0 -c 3 223.5.5.5 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
cloudflare_wired=$(ping -I eth0 -c 3 1.1.1.1 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
google_modem=$(ping -I "ppp0" -c 3 8.8.8.8 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
ali_modem=$(ping -I eth0 -c 3 223.5.5.5 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
cloudflare_modem=$(ping -I "ppp0" -c 3 1.1.1.1 | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)

# Wired Network Connection Checking
if [[ $check_current_interface_1 == "eth0" || $check_current_interface_2 == "eth0" ]]; then
  echo "Wired Network Selected" >> /etc/networkswitch.log
  if [[ $google_wired == 3 || $ali_wired == 3 || $cloudflare_wired == 3 ]]; then
	echo "Wired External Network connect Successfully , auto check it again later" >> /etc/networkswitch.log
	sleep 5s
 	rm -rf /etc/wire_network_gateway.txt
	ip route show default | awk '/default/ {print $3}' >/etc/wire_network_gateway.txt
  else
    	echo "External Network Unreachable ， Switching to Mobile Network" >> /etc/networkswitch.log
 	route add default ppp0
  	route del default eth0
  	ifmetric eth0 100
	ifmetric ppp0 0
 	sleep 5s
  fi
fi

# Mobile Network Connection Checking
if [[ $check_current_interface_1 == "ppp0" || $check_current_interface_2 == "ppp0" ]]; then
  echo "Mobile Network Selected" >> /etc/networkswitch.log
  if [[ $google_modem == 3 || $ali_modem == 3 || $cloudflare_modem == 3 ]]; then
	echo "Mobile External Network Connect Successfully , Check Wired Network" >> /etc/networkswitch.log
 	sleep 5s
  	route del default eth0
  	default_wireroute=$(cat wire_network_gateway.txt)
	route add default gw $default_wireroute metric 0
  	rm -rf /etc/mobile_network_gateway.txt
	ip route show default | awk '/default/ {print $3}' >/etc/mobile_network_gateway.txt
  fi
  if [[ $google_wired == 3 || $ali_wired == 3 || $cloudflare_wired == 3 ]]; then
    echo "Wired External Network Connected , Switching Back" >> /etc/networkswitch.log
    	route del default eth0
     	default_wireroute=$(cat wire_network_gateway.txt)
	route add default gw $default_wireroute metric 0
 	route del default ppp0
	ifmetric eth0 100
	ifmetric ppp0 0
  fi
fi

echo "Check it 10s later" >> /etc/networkswitch.log
systemctl restart NetworkSwitch
