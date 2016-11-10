#!/bin/bash -e
# to setup docker0 bridge manually

IFADDR="192.168.3.1/24" # docker0 ip address

#ip link show docker0
#if [[ $? -eq 1 ]]; then
ip link add docker0 type bridge
ip addr add "$IFADDR" dev docker0
ip link set docker0 up
iptables -t nat -A POSTROUTING -s "$IFADDR" ! -d "$IFADDR" -j MASQUERADE
#fi
echo 1 > /proc/sys/net/ipv4/ip_forward
#iptables -t nat -F
#ifconfig docker0 down
#brctl delbr docker0
