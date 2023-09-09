# setup file for AWS EC2 that supports instance store
# due to EBS bandwidth, it's quite beneficial to install and run the web UI in the instance store
# main script from https://towardsdatascience.com/create-your-own-stable-diffusion-ui-on-aws-in-minutes-35480dfcde6a
# changed a bit to load latest AUTOMATIC1111's web UI and not start it automatically

# disable the restart dialogue and install several packages
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt-get update
sudo apt install wget git python3 python3-venv build-essential net-tools awscli -y

# make filesystem for instance store
sudo mkfs -t ext4 /dev/nvme1n1

# create mount point and mount the instance store
sudo mkdir /mnt/ssd
sudo mount /dev/nvme1n1 /mnt/ssd

# change the ownership so the installer can copy the files
sudo chown ubuntu:ubuntu /mnt/ssd

# create the temp dir for gradio, in case of need
sudo mkdir /tmp/gradio
sudo chown ubuntu:ubuntu /tmp/gradio

# download AUTOMATIC1111's web UI
cd /mnt/ssd/
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

# install CUDA (from https://developer.nvidia.com/cuda-downloads)
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run
sudo sh cuda_12.2.0_535.54.03_linux.run --silent

# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/

# download some models from CivitAI
cd stable-diffusion-webui/models/Stable-diffusion/
wget https://civitai.com/api/download/models/130720 --content-disposition
wget https://civitai.com/api/download/models/150998 --content-disposition
wget https://civitai.com/api/download/models/150441 --content-disposition
wget https://civitai.com/api/download/models/153924 --content-disposition
wget https://civitai.com/api/download/models/144229 --content-disposition
wget https://civitai.com/api/download/models/148259 --content-disposition
