# dockers


### voliatlae run

Run a container, make changes, and lose all changes when the container exits

```
docker run --rm -it <image-name> /bin/bash
```

### run and save

Run a container, keep the changes, and leave the container running after exit 

```
docker run -it <image-name> /bin/bash
docker commit <container-id> <new-image-name>
```
