# What is thi repository for?

This repository will help you install Mediawiki[http://mediawiki.com] on AWS fully automated fashion using Terraforma and Ansible.

Terraform is responsible for provisioning infrastructure on AWS while Ansible helps install Mediawiki.

## Diagrams - Infra 

## Diagram - Execution

## Useful links
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-16-04

## Enabling Keyless Authentication
* Create sshkey on ansible controller server
* Add id_rsa.pub to authorized_keys on remote server
* Link: https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server
* Link: https://code-maven.com/enable-ansible-passwordless-sudo

## How to execute playbook
ansible-playbook -i non-production master-install-mediawiki.yaml -l dev-mediawiki-web --step

## How to Secure Passwords
https://www.digitalocean.com/community/tutorials/how-to-use-vault-to-protect-sensitive-ansible-data-on-ubuntu-16-04

## Preparing Master Machine
### Installing Terraform

### Installing Ansible

#### Configuring Ansible Vault

### Installing AWS CLI
#### Configuring AWS credentials

## Action Begins
### Execute Terraform
### Access Mediawiki
