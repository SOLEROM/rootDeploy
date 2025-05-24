# lxc pools

Control Where LXC Containers Are Stored

LXD uses storage pools to store:

    container root filesystems

    images

    snapshots

    volumes

By default, LXD creates a pool called default that uses:

    zfs, btrfs, or dir backend

    typically under /var/snap/lxd/common/lxd/storage-pools/default


* Don’t move container folders manually — always use lxc move or lxc export.


## create new pool

```
mkdir /data/lxcPOOL
/xc storage create mypool dir source=/data/lxcPOOL
    Storage pool mypool created

lxc storage list
```

## use per item

```
lxc launch ubuntu:24.04 my-container --storage mypool
```

## change defults

```
lxc profile edit default
```

```
lxc profile show default
   ...
    pool: mypool

```



