#!/bin/bash
check_current_interface_1=$(route | grep '^default' | grep -o '[^ ]*$')
check_current_interface_2=$(route | awk '/^default/{print $NF}')
google_wired=$(ping -I eth0 -c 3 google.com | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
baidu_wired=$(ping -I eth0 -c 3 baidu.com | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
cloudflare_wired=$(ping -I eth0 -c 3 cloudflare.com | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
google_modem=$(ping -I "ppp0" -c 3 google.com | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
baidu_modem=$(ping -I "ppp0" -c 3 baidu.com | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
cloudflare_modem=$(ping -I "ppp0" -c 3 cloudflare.com | grep 'received' | awk '{print $4}' | cut -d '/' -f 1)
# Set Metric of different network
ifmetric eth0 100
ifmetric ppp0 110
# Wired Network Connection Checking
if [ $check_current_interface_1 == "eth0" || $check_current_interface_2 == "eth0" ]; then
  echo "Wired Network Selected"
  if [ $google_wired == 3 || $baidu_wired == 3 || $cloudflare_wired == 3 ]; then
	echo "Wired External Network connect Successfully , check in 10s later"
	sleep 10s
	rm -rf /etc/wire_network_gateway.txt
	ip route show default | awk '/default/ {print $3}' >/etc/wire_network_gateway.txt
  fi
  if [ $google_wired != 3  || $baidu_wired != 3 || $cloudflare_wired != 3 ]; then
    echo "External Network Unreachable ， Switching to Mobile Network"
	route del default
	route del default
	route del default
	route add default ppp0 
	sleep 10s
  fi
fi
# Mobile Network Connection Checking
if [ $check_current_interface_1 == "ppp0" || $check_current_interface_2 == "ppp0" ]; then
  echo "Mobile Network Selected"
  ip route show default | awk '/default/ {print $3}' >/etc/mobile_network_gateway.txt
  if [ $google_modem == 3 || $baidu_modem == 3 || $cloudflare_modem == 3 ]; then
	echo "Mobile External Network connect Successfully , check in 10s later"
	sleep 10s
	rm -rf /etc/wire_network_gateway.txt
	ip route show default | awk '/default/ {print $3}' >/etc/mobile_network_gateway.txt
  fi
  if [ $google_wired == 3 || $baidu_wired == 3 || $cloudflare_wired == 3 ]; then
    echo "Wired External Network Connected ， Switching Back"
	route del default
	route del default
	route del default
        default_route=$(cat wire_network_gateway.txt)
	route add default gw $default_route metric 0
	sleep 10s
  fi
else
	echo "Total Disconnected , wait 10 second to retry"
	sleep 10s
fi
