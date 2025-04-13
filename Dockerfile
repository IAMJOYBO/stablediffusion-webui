FROM ubuntu:24.04
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /app && apt update && apt install -y sudo && chmod 777 /app
RUN echo "sd-webui ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /app
RUN groupadd -r sd-webui && useradd -r -g sd-webui sd-webui
USER sd-webui

RUN sudo apt update && sudo apt upgrade -y && sudo apt install -y vim wget curl net-tools tree git git-lfs iputils-ping
RUN sudo apt install git software-properties-common -y
RUN sudo add-apt-repository ppa:deadsnakes/ppa -y
RUN sudo apt install python3.10-venv -y
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

WORKDIR /app/stable-diffusion-webui
RUN python3.10 -m venv venv
RUN ./webui.sh

CMD ["webui.sh"]
