FROM nvcr.io/nvidia/cuda:12.6.3-cudnn-runtime-ubuntu22.04
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 创建普通用户，并赋予sudo权限，不需要输入密码
RUN mkdir -p /app && apt update && apt install -y sudo && chmod -R 777 /app && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "sd-webui ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /app
RUN groupadd -r sd-webui && useradd -m -g sd-webui sd-webui && chmod -R 777 /home/sd-webui

# 安装依赖包和用户自定义包
RUN apt update && apt upgrade -y && apt install -y vim wget curl net-tools tree git git-lfs iputils-ping libgoogle-perftools4 libtcmalloc-minimal4 software-properties-common libgl1 bc && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:deadsnakes/ppa -y && rm -rf /var/lib/apt/lists/*

# 安装Python3.10
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN apt update && apt install python3.10-venv -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# 使用sd-webui克隆仓库
USER sd-webui
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /app/stable-diffusion-webui
RUN cd extensions && git clone https://github.com/d8ahazard/sd_dreambooth_extension.git

# 创建Python虚拟环境
RUN python3.10 -m venv venv
RUN . /app/stable-diffusion-webui/venv/bin/activate && cd extensions/sd_dreambooth_extension && pip install -r requirements.txt && cd ../.. && ./webui.sh --skip-torch-cuda-test --exit && . /app/stable-diffusion-webui/venv/bin/activate && pip install xformers==0.0.29.post1 --no-deps --index-url https://download.pytorch.org/whl/cu121 && pip cache purge && sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

RUN sudo rm -rf /etc/apt/sources.list && sudo rm -rf /etc/apt/sources.list.d/*ubuntu* && sudo wget https://github.com/IAMJOYBO/stablediffusion-webui/raw/refs/heads/main/sources-22.04.list -O /etc/apt/sources.list
RUN . /app/stable-diffusion-webui/venv/bin/activate && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && pip config set install.trusted-host mirrors.aliyun.com

CMD ./webui.sh --listen --port=7860 --allow-code --api
