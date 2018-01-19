[Mucontent](https://github.com/anddimario/mucontent) system initialization

working on ubuntu (tested on 16.04)

### How-to
- add your host/hosts in inventory as `[mucontent]`
- on remote servers add your key for root user and install python (needs python2 for ansible)
- for server configuration run: ansible-playbook mucontent.yaml
- for vhost configuration run: ansible-playbook vhost.yaml
- for ssl vhost configuration run: ansible-playbook sslvhost.yaml

### Features
**mucontent.yaml**    
- check distro
- install requirements
- config nginx with some additional features
- create the user
- install pm2
- clone repo and install deps
- run app with pm2 and add app to startup
**vhost.yaml**    
- add template http
**sslvhost.yaml**    
- add template http
- copy ssl key and certificate on host


### Thanks
- https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-on-ubuntu-14-04
- https://gist.github.com/plentz/6737338
- https://www.upguard.com/blog/how-to-build-a-tough-nginx-server-in-15-steps