#!/usr/bin/bash
docker build . -f Dockerfile -t 192.168.13.73:5000/sleechengn/vllm:latest
docker push 192.168.13.73:5000/sleechengn/vllm:latest
