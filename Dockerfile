FROM ubuntu:latest
MAINTAINER Brett Neese <brett@neese.rocks>, Ryuta Otaki <otaki.ryuta@classmethod.jp>, Sergey Zhukov <sergey@jetbrains.com>

ENV region=${AWS_REGION:-us-east-1}

RUN apt-get update
RUN apt-get install -q -y python python-pip wget
RUN cd / ; wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py

ADD awslogs.conf.dummy /
RUN python /awslogs-agent-setup.py -n -r ${AWS_REGION} -c ./awslogs.conf.dummy
# ONBUILD ADD aws.conf       /var/awslogs/etc/aws.conf
# ONBUILD ADD awslogs.conf /var/awslogs/etc/awslogs.conf

ADD run-services.sh /
RUN chmod a+x /run-services.sh
CMD /run-services.sh
