## common bash script help script
source ./helpMenus.sh

#######################################################
#######################################################
# HANDLE_INPUT_PARAMS for all called scripts
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|-help|--help)
        $helpFunc
        shift # past argument
        ;;
    -o|-options|--options)
        ROOT_OPTIONS_PRINT
        shift # past argument
        exit 1
        ;;
    *)
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;

esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
#######################################################
#######################################################


function CHECK_INPUT_PARAMS_NUM_ONLY_ONE {
# check input
if [ "$1" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
}

function PATCH {
 origFile=$1
 pathFile=$2
 # -N :ignore already patch
 # -r - : disable regect file writing
 sudo patch -N -r - $origFile < $pathFile 1>/dev/null
 ##TODO: write to log by input param
}


function RUN_IN_CHROOT {
newRoot=$1
cmd=$2
sudo chroot $newRoot /bin/bash -c "$cmd"
}
