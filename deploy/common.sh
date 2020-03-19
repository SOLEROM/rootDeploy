## common bash script help script
source ./helpMenus.sh

logFile=./lastLog

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

function ECHO {
  cmd=$@
  echo "==========================================================" >> $logFile
  echo "=========================================================="
  echo $cmd
  echo "$cmd" >> $logFile
  echo "==========================================================" >> $logFile
  echo "=========================================================="
}

function RUN {
  ##befare of recurssive call
  local cmd=$@
  eval $cmd
  local retCode=$?
  LOG_WRITE "$cmd" "$retCode"
}

function LOG_WRITE {
cmd=$1
ret=$2

echo "$cmd  ; returnCode=$ret" >> $logFile
}

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
 RUN sudo patch -N -r - $origFile < $pathFile 1>/dev/null
 ##TODO: write to log by input param
}


function RUN_IN_CHROOT {
newRoot=$1
cmd=$2
rootCmd="sudo chroot $newRoot /bin/bash -c \"$cmd\""
RUN $rootCmd
}
