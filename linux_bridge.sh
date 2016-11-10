#!/bin/bash
#this is to setup a public bridge
DEV=eth0 # change it to a valid network device
IPADDR="" # update a valid ip address in ip/mask format
	# for example 10.10.10.1/24
ROUTE="" # update a valid route
ifconfig $DEV > /dev/null
if [ $? -eq 1 ]; then exit 1 ;fi
brctl addbr br-$DEV
ip link set br-$DEV up
brctl addif br-$DEV $DEV
ip addr add $IPADDR dev br-$DEV; \
    ip addr del $IPADDR dev $DEV; \
    brctl addif br-$DEV $DEV; \
    ip route del default; \
    ip route add default via $ROUTE dev br-$DEV
