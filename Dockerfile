FROM nvcr.io/nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive
COPY README.txt ./

RUN apt update && apt install -y build-essential cmake ninja-build patchelf wget net-tools curl iputils-ping git git-lfs

RUN mkdir -p /app
WORKDIR /app
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh -b -p /app/conda

RUN /app/conda/bin/conda init
RUN conda create --name ktransformers python=3.11
SHELL ["conda", "run", "-n", "ktransformers", "/bin/bash", "-c"]
RUN conda activate ktransformers
RUN conda install -c conda-forge libstdcxx-ng && strings ~/anaconda3/envs/ktransformers/lib/libstdc++.so.6 | grep GLIBCXX
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126
RUN pip install packaging ninja cpufeature numpy

RUN apt install -y libtbb-dev libssl-dev libcurl4-openssl-dev libaio1 libaio-dev libgflags-dev zlib1g-dev libfmt-dev libnuma-dev

RUN git clone https://github.com/kvcache-ai/ktransformers.git && cd ktransformers && git submodule update --init --recursive
RUN cd ktransformers && bash install.sh

RUN pip install libstdcxx-ng
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

RUN pip install huggingface_hub modelscope
RUN huggingface-cli download deepseek-ai/DeepSeek-V2-Lite-Chat --exclude *.safetensors --local-dir /app/model/deepseek-ai/DeepSeek-V2-Lite-Chat
RUN huggingface-cli download deepseek-ai/DeepSeek-V3-0324 --exclude *.safetensors --local-dir /app/model/deepseek-ai/DeepSeek-V3-0324
RUN huggingface-cli download deepseek-ai/DeepSeek-R1 --exclude *.safetensors --local-dir /app/model/deepseek-ai/DeepSeek-R1

CMD tail -f README.txt
