#!/bin/bash
IPADDR="" # ip address in ip/mask format
GATEWAY="" # update gateway
CONTAINER_NAME="" # update container name here
#docker run  -d --name $CONTAINER_NAME  nantony/debian:latest lighttpd  -f /etc/lighttpd/lighttpd.conf -D
#docker run  -it --name $CONTAINER_NAME  nantony/debian:latest
ip link add $CONTAINER_NAME-int type veth peer name $CONTAINER_NAME-ext # creating network device pair
ovs-vsctl add-port br-net0 $CONTAINER_NAME-ext # adding created device to public bridge , use i
			#https://github.com/sudeeshjohn/misctools/blob/master/br.sh for cofiguring public bridge
ifconfig $CONTAINER_NAME-ext up #bring up the device
ip link set netns $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) dev $CONTAINER_NAME-int #adding second device to the container
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip link set $CONTAINER_NAME-int up
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip addr add $IPADDR dev $CONTAINER_NAME-int
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip route del default
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip route add default via $GATEWAY dev $CONTAINER_NAME-int

