#!/usr/bin/bash
mkdir -p /opt/tmp
rm -rf /opt/tmp/vllm-build
cp -ra . /opt/tmp/vllm-build
pushd /opt/tmp/vllm-build

sed -i '1i\# syntax=docker/dockerfile:1.3' Dockerfile

sed -i "/^#APT-DEFINE.*/i\RUN apt update" Dockerfile
sed -i "/^#APT-DEFINE.*/i\RUN apt install -y ca-certificates" Dockerfile
sed -i '/^#APT-DEFINE.*/i\RUN mv /etc/apt/sources.list /etc/apt/sources.list.back' Dockerfile
sed -i '/^#APT-DEFINE.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-DEFINE.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-DEFINE.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-DEFINE.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile


sed -i '/^#PIP-MIRROR-DEFINE.*/i\ENV PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple' Dockerfile
sed -i '/^#PIP-MIRROR-DEFINE.*/i\ENV PIP_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cu126' Dockerfile

docker build . -f Dockerfile -t 192.168.13.73:5000/sleechengn/vllm:latest
docker push 192.168.13.73:5000/sleechengn/vllm:latest

popd
