[Mucontent](https://github.com/anddimario/mucontent) system initialization

working on ubuntu (tested on 16.04)

### How-to
- add your host/hosts in inventory as `[mucontent]`
- on remote servers add your key for root user and install python (needs python2 for ansible)
- run: ansible-playbook mucontent.yaml

### Features
- check distro
- install requirements
- create the user
- install pm2
- clone repo and install deps
- run app with pm2 and add app to startup
