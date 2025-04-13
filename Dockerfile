FROM nvcr.io/nvidia/cuda:12.6.3-cudnn-runtime-ubuntu22.04
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /app && apt update && apt install -y sudo && chmod 777 /app
RUN echo "sd-webui ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /app
RUN groupadd -r sd-webui && useradd -r -g sd-webui sd-webui
USER sd-webui

RUN sudo apt update && sudo apt upgrade -y && sudo apt install -y vim wget curl net-tools tree git git-lfs iputils-ping
RUN sudo apt install -y libgoogle-perftools4 libtcmalloc-minimal4
RUN sudo apt install git software-properties-common -y
RUN sudo add-apt-repository ppa:deadsnakes/ppa -y

RUN sudo sh -c 'echo "Asia/Shanghai" > /etc/timezone' && DEBIAN_FRONTEND=noninteractive sudo apt install python3.12-venv -y --no-install-recommends
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /app/stable-diffusion-webui
RUN cd extensions && git clone https://github.com/d8ahazard/sd_dreambooth_extension.git
RUN source venv/bin/activate && cd extensions/sd_dreambooth_extension && pip install -r requirements.txt
RUN python3.10 -m venv venv
RUN ./webui.sh --skip-torch-cuda-test
RUN source venv/bin/activate && pip install -U torch torchvision torchaudio xformers --index-url https://download.pytorch.org/whl/cu126

CMD ["./webui.sh"]
