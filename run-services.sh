#!/bin/bash

shutdown_awslogs()
{
    echo "Stopping container..."
    kill $(pgrep -f /var/awslogs/bin/aws)
    exit 0
}

trap shutdown_awslogs INT TERM HUP

/var/awslogs/bin/awslogs-agent-launcher.sh &

wait
