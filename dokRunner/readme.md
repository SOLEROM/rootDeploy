#


## exmpale

```
IMAGE_NAME="dockerAPP:dev"
CONTAINER_NAME="APP1"
ENV_FILE="mb_env.list"
HOST_PROJECT_DIR="/home/user/proj/APPX"
CONTAINER_PROJECT_DIR="/home/docker/user"
EXTRA_VOLUMES="-v /home/user/proj/pip.conf:/etc/pip.conf"
DISPLAY_VAR="localhost:11.0"



# Build explicitly with a given Dockerfile
./devRunner.sh build -f Dockerfile.app1 -t appRuner1:dev

# Run your script (auto-build if needed, using default Dockerfile)
./devRunner.sh run -- python3 src/app1.py --param1

# Or use the shortcut:
./devRunner.sh python3 src/app1.py --param1

# Open an interactive shell in the container env:
./devRunner.sh shell


```
