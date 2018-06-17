#!/bin/sh

# Try to retrieve port from PIA and parse JSON
# PORT=$(./pia_portforward.sh | jq -r '.port')
PORT=$(./pia_portforward.sh | jq -r '.port')

echo Port forwarding on $PORT

echo $PORT > port.txt
