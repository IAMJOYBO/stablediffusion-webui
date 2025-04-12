FROM ubuntu:22.04
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive
COPY README.txt ./

# 安装基础环境
RUN apt update && apt upgrade -y && apt install -y build-essential cmake ninja-build patchelf wget net-tools curl iputils-ping git git-lfs apt-utils

# 安装cmake、gcc、g++
RUN wget https://github.com/Kitware/CMake/releases/download/v4.0.1/cmake-4.0.1-linux-x86_64.sh && echo y | bash cmake-4.0.1-linux-x86_64.sh
RUN apt install -y gcc g++ && apt list --installed | grep -E "gcc|g++|cmake"

# 安装CUDA、NVCC
RUN wget https://github.com/IAMJOYBO/ktransformers/raw/refs/heads/main/CUDA_ENV.sh && bash CUDA_ENV.sh
RUN wget https://github.com/IAMJOYBO/ktransformers/raw/refs/heads/main/cuda-toolkit.sh && bash cuda-toolkit.sh
RUN wget https://github.com/IAMJOYBO/ktransformers/raw/refs/heads/main/nvcc.sh && bash nvcc.sh

# 安装Conda环境
RUN mkdir -p /app
WORKDIR /app
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh -b -p /app/miniconda
RUN /app/miniconda/bin/conda init
ENV PATH=/app/miniconda/bin:$PATH
RUN echo yes | conda update conda

# 创建并激活Conda环境
RUN echo yes | conda create --name ktransformers python=3.11
SHELL ["conda", "run", "-n", "ktransformers", "/bin/bash", "-c"]
RUN conda install -c conda-forge libstdcxx-ng && strings /app/miniconda/envs/ktransformers/lib/libstdc++.so.6 | grep GLIBCXX
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126
RUN pip install packaging ninja cpufeature numpy

# 依赖环境部署
RUN apt install -y libtbb-dev libssl-dev libcurl4-openssl-dev libaio1 libaio-dev libgflags-dev zlib1g-dev libfmt-dev libnuma-dev

# KTransformers环境部署
RUN git clone https://github.com/kvcache-ai/ktransformers.git && cd ktransformers && git submodule update --init --recursive
RUN /app/miniconda/envs/ktransformers/bin/python -m pip install -U pip && pip install -U wheel setuptools
RUN cd ktransformers && bash install.sh

# 下载大模型配置
RUN pip install huggingface_hub modelscope
RUN huggingface-cli download deepseek-ai/DeepSeek-V2-Lite-Chat --exclude *.safetensors --local-dir /app/model/deepseek-ai/DeepSeek-V2-Lite-Chat
RUN huggingface-cli download deepseek-ai/DeepSeek-V3-0324 --exclude *.safetensors --local-dir /app/model/deepseek-ai/DeepSeek-V3-0324
RUN huggingface-cli download deepseek-ai/DeepSeek-R1 --exclude *.safetensors --local-dir /app/model/deepseek-ai/DeepSeek-R1

# 配置国内源
RUN pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
# RUN mkdir -p /app/index-tts && rm -rf /etc/apt/sources.list && rm -rf /etc/apt/sources.list.d/*ubuntu*
# COPY sources-22.04.list /etc/apt/sources.list

# 启动命令
CMD tail -f README.txt
