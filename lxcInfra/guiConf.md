# gui config 

* enable
sudo snap set lxd ui.enable=true
* set:
lxc config set core.https_address :9001
* test:
lxc config get core.https_address

follow the link to add credentials:

https://127.0.0.1:9001