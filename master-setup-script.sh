#!/bin/bash

# Pre-Setup
sudo apt-get update 
sudo apt-get -y upgrade
sudo apt -y install python-pip
sudo pip install --upgrade pip
sudo apt -y install unzip

# Install Terraform
curl -O https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
sudo mkdir /bin/terraform
sudo unzip terraform_0.11.13_linux_amd64.zip -d /bin/terraform
export PATH=$PATH:/bin/terraform

# Install AWS CLI
sudo pip install awscli --upgrade

# Install Ansible
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible