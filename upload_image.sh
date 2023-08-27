#!/bin/bash
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/w3w5l3i9
docker build -t jorge-apache .
docker tag jorge-apache:latest public.ecr.aws/w3w5l3i9/jorge-apache:latest
docker push public.ecr.aws/w3w5l3i9/jorge-apache:latest