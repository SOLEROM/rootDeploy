# config ssh and wifi

* mount sd
* Enable ssh

```
touch /Volumes/boot/ssh
```

* Add network info (create a new empty file:)

```
/Volumes/boot/wpa_supplicant.conf
=================================
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="NETWORK-NAME"
    psk="NETWORK-PASSWORD"
}
```
* Login over Wifi

```
ssh-keygen -R raspberrypi.local
ssh pi@raspberrypi.local
```

* Change your Hostname and Password

```
sudo raspi-config
```

* update

```
sudo apt-get update -y
sudo apt-get upgrade -y
```

## run on cable

```
/Volumes/boot/config.txt
========================
dtoverlay=dwc2
```

```
/Volumes/boot/cmdline.txt
=========================

### After rootwait, append this text leaving only one space between rootwait and the new text

modules-load=dwc2,g_ether


```
* boot
* Plug a Micro-USB cable into the data/peripherals port
* You do NOT need to plug in external power – it will get it from your computer
* Login over USB

```
ssh-keygen -R raspberrypi.local
ssh pi@raspberrypi.local
                          //password – by default this is raspberry
```

## share internet connections form host

```
sudo ifconfig enp0s20f0u2 192.168.7.1
sudo sysctl net.ipv4.ip_forward=1
sudo iptables --table nat --append POSTROUTING --out-interface wlp2s0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface enp0s20f0u2 -j ACCEP

```

