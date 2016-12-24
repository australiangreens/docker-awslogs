## Dockerfile to run AWS CloudWatch Logs container

### Usage

This container is intended to upload logfiles to Amazon CloudWatch Logs service.
If you don't set any environment variables, container will start with the following config:

```
[/var/log/messages]
datetime_format = %d/%b/%Y:%H:%M:%S %z
file = /mnt/var/log/messages
buffer_duration = 5000
log_stream_name = {instance_id}-$logfile
initial_position = start_of_file
log_group_name = logs
```

### Environment variables

* `AWS_REGION` default is "us-east-1" - specify cloudwatch region
* `AWS_LOGFILES` default is "/var/log/messages" - specify multiple log files using colon prefixes, ie "/var/log/messages:/var/log/syslog"
* `AWS_LOGFORMAT` default is "%d/%b/%Y:%H:%M:%S %z"
* `AWS_DURATION` default is "5000"
* `AWS_GROUPNAME` default is "logs"

### Example

```
# Run CloudWatch logs uploader
docker run -d --name awslogs -e AWS_LOGFILES=/var/log/access.log: -e AWS_DURATION=10000 -v /var/log:/mnt/var/log hbkengineering/docker-awslogs

# Run CloudWatch logs uploader with multiple logs
docker run -d --name awslogs -e AWS_GROUPNAME=/rancher-os/development -e AWS_LOGFILES=/var/log/docker.log:/var/log/system-docker.log:/var/log/messages:/var/log/secure:/var/log/syslog -e AWS_REGION=us-east-2 -e AWS_DURATION=10000 -v /var/log:/mnt/var/log hbkengineering/docker-awslogs

```

Note that we assume that the host log directory is mounted to the Docker image under /mnt. This allows specifying the files as they appear on the host (/var/log/whatever),
without interfering with the image's /var/log directory. This doesn't mean you can't grab logs from other folders, simply make sure to mount 
them under /mnt (ie -v /host/log/directory:/mnt/host/log/directory). See line #33 of run-services.sh.

Now you can see access logs of your Nginx at [AWS Console](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logs:). 

NOTE: Of course you should run it on the Amazon EC2 and you should set IAM role for you instance according [manual](http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/QuickStartEC2Instance.html).

### MAINTAINERS

* Brett Neese <brett@neese.rocks>
* Ryuta Otaki <otaki.ryuta@classmethod.jp>
* Sergey Zhukov <sergey@jetbrains.com>
