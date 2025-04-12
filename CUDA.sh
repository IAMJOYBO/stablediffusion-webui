# Adding CUDA to PATH
if [ -d "/usr/local/cuda/bin" ]; then
    export PATH=$PATH:/usr/local/cuda/bin
fi

if [ -d "/usr/local/cuda/lib64" ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
    # Or you can add it to /etc/ld.so.conf and run ldconfig as root:
    # echo "/usr/local/cuda-12.x/lib64" | sudo tee -a /etc/ld.so.conf
    # sudo ldconfig
fi

if [ -d "/usr/local/cuda" ]; then
    export CUDA_PATH=$CUDA_PATH:/usr/local/cuda
fi
