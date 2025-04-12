wget https://developer.download.nvidia.com/compute/cudnn/9.8.0/local_installers/cudnn-local-repo-ubuntu2004-9.8.0_1.0-1_amd64.deb
dpkg -i cudnn-local-repo-ubuntu2004-9.8.0_1.0-1_amd64.deb
cp /var/cudnn-local-repo-ubuntu2004-9.8.0/cudnn-*-keyring.gpg /usr/share/keyrings/
apt-get update
apt-get -y install cudnn
apt-get -y install cudnn-cuda-12
