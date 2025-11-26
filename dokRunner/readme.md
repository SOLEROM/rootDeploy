#


## exmpale

```
IMAGE_NAME="dockerAPP:dev"
CONTAINER_NAME="APP1"
ENV_FILE="mb_env.list"
HOST_PROJECT_DIR="/home/user/proj/APPX"
CONTAINER_PROJECT_DIR="/home/docker/user"
EXTRA_VOLUMES="-v /home/zvv/proj/pip.conf:/etc/pip.conf"
DISPLAY_VAR="localhost:11.0"

./dev-container.sh python3 appRunner1.py --someParam
./dev-container.sh           # to drop into an interactive shell in that env

```
