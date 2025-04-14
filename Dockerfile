FROM nvcr.io/nvidia/cuda:12.6.3-cudnn-runtime-ubuntu22.04
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 创建普通用户，并赋予sudo权限，不需要输入密码
RUN mkdir -p /app && apt update && apt install -y sudo && chmod -R 777 /app
RUN echo "sd-webui ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /app
RUN groupadd -r sd-webui && useradd -r -g sd-webui sd-webui && chmod -R 777 /home/sd-webui

# 安装依赖包和用户自定义包
RUN apt update && sudo apt upgrade -y && apt install -y vim wget curl net-tools tree git git-lfs iputils-ping
RUN apt install -y libgoogle-perftools4 libtcmalloc-minimal4
RUN apt install git software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y

# 安装Python3.10
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN apt install python3.10-venv -y

# 清除apt缓存
RUN rm -rf /var/lib/apt/lists/*

# 使用sd-webui克隆仓库
USER sd-webui
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /app/stable-diffusion-webui
RUN cd extensions && git clone https://github.com/d8ahazard/sd_dreambooth_extension.git

# 创建Python虚拟环境
RUN python3.10 -m venv venv
RUN . /app/stable-diffusion-webui/venv/bin/activate && cd extensions/sd_dreambooth_extension && pip install -r requirements.txt
RUN ./webui.sh --exit

# 清理缓存
RUN . /app/stable-diffusion-webui/venv/bin/activate && pip cache purge

CMD ./webui.sh --listen --port=7860 --allow-code --api --xformers
