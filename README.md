## Dockerfile to run AWS CloudWatch Logs container

Forked from [HBKEngineering/docker-awslogs](https://github.com/HBKEngineering/docker-awslogs)
and heavily customised to suit Australian Greens needs.

### Usage

This container is intended to upload logfiles to Amazon CloudWatch Logs service.

### Defining log groups, streams, files

Done via a config file mounted from Kubernetes secret.
