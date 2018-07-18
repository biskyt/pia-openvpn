#!/bin/bash

# Try to retrieve port from PIA and parse JSON
PORT=$(./pia_portforward.sh | jq -r '.port')

echo Port forwarding on $PORT
if [ "$json" == "" ]; then
    echo Port forwarding on $PORT
    echo $PORT > /portforward/port.txt
else
    echo Port Forward failed to retrieve a port
    exit 1
fi

exit 0


