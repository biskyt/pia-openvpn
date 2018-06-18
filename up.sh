#!/bin/bash

# spawn second script in new process so VPN finsihes connecting
# Works around issue with PIA API not returning port forward until after connection has completed
bash up2.sh &
echo "up finished"
