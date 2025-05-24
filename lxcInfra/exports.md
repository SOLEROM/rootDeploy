# exports

lxc stop my-template
lxc export my-template my-template.tar.gz


* import


lxc import my-template.tar.gz --alias my-image
lxc launch my-image my-new-dev