# This script is designed to work with ubuntu 18.04 LTS
# ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common


read -r -p  "Is Nvidia GPU installed? (y/n)"  -n  1 IsGPUInstalled
echo # (optional) move to a new line


if [[ $IsGPUInstalled =~ ^[yY]$ ]]
then

	# download and install GPU drivers
	#Download cuda local repository for Ubuntu
	# Base Installer of cuda 9.0
	wget "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1704-9-0-local_9.0.176-1_amd64-deb" -O "cuda-repo-ubuntu1704-9-0-local_9.0.176-1_amd64-deb"

	#Install the repository locally
	sudo cuda-repo-ubuntu1704-9-0-local_9.0.176-1_amd64-deb

	#Register Nvidia Key
	sudo apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub

	#Update and install cuda and nvidia-drivers
	sudo apt-get update
	sudo apt-get install -y cuda


	#Load the NVIDIA kernel module and create NVIDIA character device files
	sudo modprobe nvidia

	#To verify if the video card is correctly installed execute 
	nvidia-smi


	#install cudnn
	#download cudnn 7.2
	wget "https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.2.1/prod/9.2_20180806/cudnn-9.2-linux-x64-v7.2.1.38.tgz?ajm9mXlmmRbIcWmRsFjHRLS27l9ryKs0rAzBgzFIMPS-Vi9l1mVNUJo3iIh4wKSFoJbrCnBOG0cIKw2IOPZIvUElvRdBDDbmI2bznKBETGWXC4eDKKRZj3MPZcpWqYs0TPqtlcjjZYOFHA2FFj0iCNf4-DEea-QwqSjPW56O8i08rpSFxb5UvP--z_wQ89lz2IZGcTGWxN5BKzpGZsjX" -O "cudnn-9.2-linux-x64-v7.2.1.38.tgz"
	tar -zxf cudnn.tgz
	cd cuda
	sudo cp lib64/* /usr/local/cuda/lib64/
	sudo cp include/* /usr/local/cuda/include/
else
        echo "No Nvidia GPU is installed."
fi

#Install Python, pip, and virtualenv
sudo apt-get install python3-pip python3-dev python-virtualenv


#Create a directory for the virtual environment and choose a Python interpreter.
mkdir ~/tensorflow 
cd ~/tensorflow
virtualenv --system-site-packages -p python3 venv

#Activate the Virtualenv environment.
source ~/tensorflow/venv/bin/activate

#Upgrade pip in the virtual environment
pip install -U pip

#install jupyter notebook
pip install jupyter

# configure jupyter and prompt for password
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

if [[ $IsGPUInstalled =~ ^[yY]$ ]]
then
	#Install TensorFlow with GPU support in the virtual environment.
	pip install -U tensorflow-gpu
else
	#Install TensorFlow without GPU support(CPU only) in the virtual environment.
	#Install the Intel® Optimization for TensorFlow* Wheel Into an Existing Python* Installation Through PIP
	#pip install https://storage.googleapis.com/intel-optimized-tensorflow/tensorflow-1.9.0-cp36-cp36m-linux_x86_64.whl
	#pip install https://storage.googleapis.com/intel-optimized-tensorflow/tensorflow-1.10.0-cp36-cp36m-linux_x86_64.whl
	pip install -U tensorflow
fi

pip install pandas
pip install h5py
pip install keras

# Validate the install and test the version
python -c "import tensorflow as tf; print(tf.__version__)"
