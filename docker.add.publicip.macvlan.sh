#!/bin/bash
IPADDR="" # ip address in ip/mask format
GATEWAY="" # update gateway
CONTAINER_NAME="" # update container name here
NET_DEVICE=""
#docker run  -d --name $CONTAINER_NAME  nantony/debian:latest lighttpd  -f /etc/lighttpd/lighttpd.conf -D
#docker run  -it --name $CONTAINER_NAME  nantony/debian:latest

ip link add $NET_DEVICEp0 link $NET_DEVICE  type macvlan mode bridge
sleep 2
ifconfig $NET_DEVICE"p0" up
ip link set netns $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) dev $NET_DEVICEp0 #adding device to container
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip link set $NET_DEVICEp0 up
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip addr add $IPADDR dev $NET_DEVICEp0
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip route del default
nsenter -t $(docker inspect -f '{{ .State.Pid }}' $CONTAINER_NAME) -n ip route add default via $GATEWAY dev $NET_DEVICEp0

