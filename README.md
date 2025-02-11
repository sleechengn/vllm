vllm

生成式AI对话，Docker容器

编排

```
networks:
  ollama-network:
  lan13:
    name: lan13
    driver: macvlan
    driver_opts:
      parent: enp6s19
    ipam:
      config:
        - subnet: "192.168.13.0/24"
          gateway: "192.168.13.1"
services:
  vllm:
    container_name: "vllm"
    hostname: "vllm"
    build: 
      context: https://github.com/sleechengn/vllm
      dockerfile: Dockerfile
    restart: unless-stopped
    command: ["Qwen/Qwen2.5-1.5B-Instruct"]
    environment:
      - TZ=Asia/Shanghai
      - NVIDIA_DRIVER_CAPABILITIES=all
      - NVIDIA_VISIBLE_DEVICES=all
    runtime: nvidia
    networks:
      lan13:
        ipv4_address: 192.168.13.75
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

访问方法 openai 兼容

http://ip:8000
