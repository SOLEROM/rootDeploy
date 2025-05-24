# templates

create
```
lxc launch ubuntu:24.04 my-template
lxc exec my-template -- bash
# → install packages, tools, config, ROS2, user setup, etc.
```

save
```
lxc stop my-template
lxc publish my-template --alias my-image
```

launch new
```
lxc launch my-image dev1
lxc launch my-image dev2
lxc launch my-image dev3
```