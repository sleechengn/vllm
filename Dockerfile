from ubuntu:jammy

#APT-DEFINE

run apt update \
	&& apt install -y curl openssh-server nano net-tools procps iputils-ping

run set -e \
	&& apt install -y wget aria2 \
	&& mkdir -p /opt/uv \
	&& aria2c -x 10 -j 10 -k 1M -o "/opt/uv/uv.tar.gz" "https://github.com/astral-sh/uv/releases/download/0.6.9/uv-x86_64-unknown-linux-gnu.tar.gz" \
	&& cd /opt/uv \
	&& tar -zxvf uv.tar.gz \
	&& rm -rf uv.tar.gz \
	&& ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uv /usr/bin/uv \
	&& ln -s /opt/uv/uv-x86_64-unknown-linux-gnu/uvx /usr/bin/uvx

#PIP-MIRROR-DEFINE

run set -e \
	&& echo '#!/usr/bin/bash' >> /opt/install.sh \
	&& echo 'uv venv /opt/venv --python 3.12 --seed' >> /opt/install.sh \
	&& echo 'source /opt/venv/bin/activate' >> /opt/install.sh \
	&& echo 'uv pip install vllm' >> /opt/install.sh \
	&& chmod +x /opt/install.sh \
	&& /opt/install.sh \
	&& rm -rf /opt/install.sh

run set -e \
	&& echo '#!/usr/bin/bash' >> /docker-entrypoint.sh \
	&& echo 'source /opt/venv/bin/activate' >> /docker-entrypoint.sh \
	&& echo 'vllm serve $*' >> /docker-entrypoint.sh \
	&& chmod +x /docker-entrypoint.sh

run echo '#!/usr/bin/bash' >> /opt/post.sh \
        && echo 'source /opt/venv/bin/activate' >> /opt/post.sh \
        && echo 'uv pip install modelscope' >> /opt/post.sh \
        && chmod +x /opt/post.sh \
	&& /opt/post.sh \
	&& rm -rf /opt/post.sh

run set -e \
	&& . /opt/venv/bin/activate \
	&& pip install gguf --force-reinstall

run mkdir /opt/hf_home
env HF_HOME=/opt/hf_home
volume /opt/hf_home

run mkdir /opt/ms_home
env MODELSCOPE_CACHE=/opt/ms_home
volume /opt/ms_home

volume /root

cmd []
entrypoint ["/docker-entrypoint.sh"]
