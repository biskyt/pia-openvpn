#!/bin/bash

# wait, to give connection a chance to complete
sleep 5

rm /portforward/pia_client_id 

# Try to retrieve port from PIA and parse JSON
PORT=$(./pia_portforward.sh | jq -r '.port')

echo Port forwarding on $PORT

echo $PORT > /portforward/port.txt
