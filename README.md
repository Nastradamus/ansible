# Provision CentOS 7 in the yandex cloud

Example of Yandex Cloud CentOS 7 virtual machine provision

## Setup

- make virtual machine with login and ssh public key
- edit ansible.cfg and change your login and private key file
- install python or keep system `python 2.7`
- pip install -r requirements.txt -y

## Run provision

(please use your VM hostname instead of "back", I use /etc/hosts )

```bash

ansible-playbook common.yml -i 'back,' -D -b -v

```

