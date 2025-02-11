from ubuntu:jammy
user root
run apt update \
	&& apt install -y curl openssh-server nano net-tools procps iputils-ping

run cd /root \
	&& apt install -y wget \
	&& wget https://astral.sh/uv/install.sh \
	&& bash install.sh

run rm -rf /root/install.sh
run echo 'source /root/.local/bin/env' >> /root/.bashrc \
	&& echo '#!/usr/bin/bash' >> /opt/install.sh \
	&& echo 'source /root/.local/bin/env' >> /opt/install.sh \
	&& echo 'uv venv /opt/venv --python 3.12 --seed' >> /opt/install.sh \
	&& echo 'source /opt/venv/bin/activate' >> /opt/install.sh \
	&& echo 'uv pip install vllm' >> /opt/install.sh \
	&& chmod +x /opt/install.sh \
	&& /opt/install.sh \
	&& rm -rf /opt/install.sh
run echo 'source /opt/venv/bin/activate' >> /root/.bashrc \
	&& echo '#!/usr/bin/bash' >> /docker-entrypoint.sh \
	&& echo 'source /root/.local/bin/env' >> /docker-entrypoint.sh \
	&& echo 'source /opt/venv/bin/activate' >> /docker-entrypoint.sh \
	&& echo 'vllm serve $*' >> /docker-entrypoint.sh \
	&& chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]
