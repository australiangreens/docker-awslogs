#!/bin/sh

shutdown_awslogs()
{
    echo "Stopping container..."
    kill $(pgrep -f /var/awslogs/bin/aws)
    exit 0
}

trap shutdown_awslogs INT TERM HUP

# [/var/log/logfile]
# datetime_format = %d/%b/%Y:%H:%M:%S %z
# file = /mnt/logs/access.log
# buffer_duration = 5000
# log_stream_name = {instance_id}-$logfile
# initial_position = start_of_file
# log_group_name = logs

LOGFILES=${AWS_LOGFILES:-"/mnt/var/log/messages"}
LOGFORMAT=${AWS_LOGFORMAT:-"%d/%b/%Y:%H:%M:%S %z"}
DURATION=${AWS_DURATION:-"5000"}
GROUPNAME=${AWS_GROUPNAME:-"logs"}
REGION=${AWS_REGION:-"us-east-1"}

cp -f /awslogs.conf.dummy /var/awslogs/etc/awslogs.conf

cat > /var/awslogs/etc/aws.conf <<EOF
[plugins]
cwlogs = cwlogs
[default]
region = $REGION
EOF

(IFS=:
for LOGFILE in $LOGFILES; do
      o="$o
[${LOGFILE}]
datetime_format = ${LOGFORMAT}
file = /mnt${LOGFILE}
buffer_duration = ${DURATION}
log_stream_name = {ip_address}/${LOGFILE}
initial_position = start_of_file
log_group_name = ${GROUPNAME}
"
done

cat >> /var/awslogs/etc/awslogs.conf <<EOF
    $o
EOF
)

/var/awslogs/bin/awslogs-agent-launcher.sh &

wait
