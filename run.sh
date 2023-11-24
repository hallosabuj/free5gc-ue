#!/bin/bash

sudo ip link del ipsec-default
sduo ip link del gretun-id-1
sudo ip route del default dev gretun-id-1
go build ue.go
sudo ./ue