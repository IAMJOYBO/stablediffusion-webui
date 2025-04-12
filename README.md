# 清华大学 KTransformers Docker Image Build
## Docker镜像列表
|序号|镜像|版本|
| ----------- | ----------- | ----------- |
|01|registry.cn-hangzhou.aliyuncs.com/joybo/ktransformers|v2025.4.12-action|
## Docker Compose 示例
```yaml
services:
  ktransformers:
    image: ktransformers
    container_name: ktransformers
    hostname: ktransformers
    environment:
      - TZ=Asia/Shanghai
      # - NVIDIA_VISIBLE_DEVICES=0
    volumes:
      - ./DeepSeek-V2-Lite-GGUF:./model/DeepSeek-V2-Lite-GGUF
    ports:
      - "10002:10002"
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
          - driver: nvidia
            # device_ids: ['0']
            capabilities: [gpu]
    stdin_open: true
    tty: true
    restart: no
    networks:
      - ktransformers
    command: ktransformers --model_path /app/model/deepseek-ai/DeepSeek-V2-Lite-Chat --gguf_path /app/model/DeepSeek-V2-Lite-GGUF  --port 10002 --web True

networks:
  ktransformers:
    driver: bridge
    name: ktransformers
```
