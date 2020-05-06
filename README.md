# Provision CentOS 7 in the yandex cloud

Example of Yandex Cloud CentOS 7 virtual machine provision

## Setup

- make virtual machine with login and ssh public key
- edit ansible.cfg and change your login and private key file
- install `python 2.7` and pip 2.7 (default for MacOS)
- `sudo ./preinstall_ansible.sh` # needs sudo for pip on MacOS

## Run provision

(please use your VM hostname instead of "back", I use /etc/hosts )

```bash

# Basic provision
ansible-playbook common.yml -i 'back,' -D -b -v

# Install LT kernel and upgrade

ansible-playbook kernel-lt.yml -i 'back,' -D -b -v

```

