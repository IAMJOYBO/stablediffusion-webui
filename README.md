# 清华大学 KTransformers Docker Image Build Tool
## Docker镜像
### registry.cn-hangzhou.aliyuncs.com/joybo/ktransformers
|序号|Tag|构建时间|指令集|PyTorch版本|New|WEB|
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
|01|v2025.4.12-action|2025.4.12|NATIVE|2.6.0+cu126|[最新镜像](https://github.com/IAMJOYBO/ktransformers/actions/workflows/docker_build.yaml)|❌|
|02|v2025.4.13-action-web|2025.4.13|NATIVE|2.6.0+cu126|[最新镜像](https://github.com/IAMJOYBO/ktransformers/actions/workflows/docker_build_web.yaml)|✅|
> PyTorch基础镜像：[https://hub.docker.com/r/pytorch/pytorch/tags](https://hub.docker.com/r/pytorch/pytorch/tags)
### Docker Compose 示例（无WEB）
```yaml
services:
  ktransformers:
    image: registry.cn-hangzhou.aliyuncs.com/joybo/ktransformers:v2025.04.12-action
    container_name: ktransformers
    hostname: ktransformers
    environment:
      - TZ=Asia/Shanghai
      # - NVIDIA_VISIBLE_DEVICES=0
    volumes:
      - ./DeepSeek-V2-Lite-Chat-GGUF:/app/model/DeepSeek-V2-Lite-Chat-GGUF
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
    entrypoint: ["python", "-m", "ktransformers.local_chat", "--model_path=/app/model/DeepSeek-V2-Lite-Chat", "--gguf_path=/app/model/DeepSeek-V2-Lite-Chat-GGUF"]

networks:
  ktransformers:
    driver: bridge
    name: ktransformers
```
### Docker Compose 示例（带WEB）
#### API目录：直接访问 http://<IP地址>:10002/docs 进入到 api 的目录，具体请参见 [fastapi](https://fastapi.tiangolo.com/zh/#api) 官方文档
#### 进入聊天：http://<IP地址>:10002/web/index.html#/chat
```yaml
services:
  ktransformers:
    image: registry.cn-hangzhou.aliyuncs.com/joybo/ktransformers:v2025.04.13-action-web
    container_name: ktransformers
    hostname: ktransformers
    environment:
      - TZ=Asia/Shanghai
      # - NVIDIA_VISIBLE_DEVICES=0
    volumes:
      - ./DeepSeek-V2-Lite-Chat-GGUF:/app/model/DeepSeek-V2-Lite-Chat-GGUF
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
    entrypoint: ["ktransformers", "--model_path=/app/model/DeepSeek-V2-Lite-Chat", "--gguf_path=/app/model/DeepSeek-V2-Lite-Chat-GGUF", "--port=10002", "--web=True"]

networks:
  ktransformers:
    driver: bridge
    name: ktransformers
```
### Docker Image 说明
```
【预下载的模型配置】
1、DeepSeek-R1：/app/model/DeepSeek-R1
2、DeepSeek-V3-0324：/app/model/DeepSeek-V3-0324
3、DeepSeek-V2-Lite-Chat：/app/model/DeepSeek-V2-Lite-Chat

【启动命令：LocalChat】（GGUF文件需要下载到对应的目录内，仅允许存在GGUF文件，且不允许存在多个不同量化版本的GGUF）
1、DeepSeek-R1：python -m ktransformers.local_chat --model_path=/app/model/DeepSeek-R1 --gguf_path=/app/model/DeepSeek-R1-GGUF
2、DeepSeek-V3-0324：python -m ktransformers.local_chat --model_path=/app/model/DeepSeek-V3-0324 --gguf_path=/app/model/DeepSeek-V3-0324-GGUF
3、DeepSeek-V2-Lite-Chat：python -m ktransformers.local_chat --model_path=/app/model/DeepSeek-V2-Lite-Chat --gguf_path=/app/model/DeepSeek-V2-Lite-Chat-GGUF

【启动命令：WEB服务】（GGUF文件需要下载到对应的目录内，仅允许存在GGUF文件，且不允许存在多个不同量化版本的GGUF）
1、DeepSeek-R1：ktransformers --model_path=/app/model/DeepSeek-R1 --gguf_path=/app/model/DeepSeek-R1-GGUF --port=10002 --web=True
2、DeepSeek-V3-0324：ktransformers --model_path=/app/model/DeepSeek-V3-0324 --gguf_path=/app/model/DeepSeek-V3-0324-GGUF --port=10002 --web=True
3、DeepSeek-V2-Lite-Chat：ktransformers --model_path=/app/model/DeepSeek-V2-Lite-Chat --gguf_path=/app/model/DeepSeek-V2-Lite-Chat-GGUF --port=10002 --web=True

【部分GGUF的地址：国内可访问】
1、DeepSeek-R1：https://hf-mirror.com/unsloth/DeepSeek-R1-GGUF
2、DeepSeek-V3-0324：https://hf-mirror.com/unsloth/DeepSeek-V3-0324-GGUF
3、DeepSeek-V2-Lite-Chat：https://hf-mirror.com/mradermacher/DeepSeek-V2-Lite-Chat-GGUF
```
## 官方仓库
[https://github.com/kvcache-ai/ktransformers.git](https://github.com/kvcache-ai/ktransformers.git)
## 官方部署文档
[https://kvcache-ai.github.io/ktransformers/en/install.html](https://kvcache-ai.github.io/ktransformers/en/install.html)
## WEB 部署文档
[https://kvcache-ai.github.io/ktransformers/en/api/server/website.html](https://kvcache-ai.github.io/ktransformers/en/api/server/website.html)
## Docker 部署文档
[https://github.com/kvcache-ai/ktransformers/blob/main/doc/en/Docker.md](https://github.com/kvcache-ai/ktransformers/blob/main/doc/en/Docker.md)
## Dockerfile 文件
[https://github.com/kvcache-ai/ktransformers/blob/main/Dockerfile](https://github.com/kvcache-ai/ktransformers/blob/main/Dockerfile)

# Star History

[![Star History Chart](https://api.star-history.com/svg?repos=IAMJOYBO/ktransformers&type=Date)](https://www.star-history.com/#IAMJOYBO/ktransformers&Date)

