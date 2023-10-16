#!/bin/bash

if [[ $# -ne 1 ]] || ([[ $1 != "up" ]] && [[ $1 != "down" ]]); then
  echo "Usage: $0 [up|down] "
  exit 1
fi

# Here I am considering enp0s8 as the wlan1
if [[ $1 == "up" ]]; then
  sudo ip route add 10.0.0.0/24 via 192.168.56.123 dev enp0s8

  # settings for ipsec
  sudo ip link add name ipsec-default type vti local 192.168.56.124 remote 0.0.0.0  key 5
  sudo ip addr add 10.0.0.1/24 dev ipsec-default
  sudo ip link set ipsec-default up

elif [[ $1 == "down" ]]; then
  echo "Removing network interfaces and namespaces.."
  
  sudo ip link del ipsec-default

  sudo ip route del 10.0.0.0/24 via 192.168.56.124
  echo "Network interfaces and namespaces removed."
fi

# Commands to delete xfrm state and policy
sudo ip xfrm state deleteall
sudo ip xfrm policy deleteall
