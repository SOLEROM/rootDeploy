

xhost +local:

lxc config device add ubu24TemplateX X0 disk source=/tmp/.X11-unix path=/tmp/.X11-unix

lxc exec ubu24TemplateX --env DISPLAY=:0 -- bash