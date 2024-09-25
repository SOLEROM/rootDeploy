## common bash script help script
source ./helpMenus.sh

logFile=./lastLog

function setVersion {
case $1 in
    16)
	ubuVer=16
	ubuAdd=./ubu16Additions
        ;;	
    18)
	ubuVer=18
	ubuAdd=./ubu18Additions
        ;;
    *)
	echo "illegal version choosen"
	exit -1
	;;
esac
}


function setNewRoot {
newRoot=$1
}


function CHECK_VERSION_SET {
if [ -z "$ubuVer" ] ; then
echo "ubu version is not set ; use -v option; exit"
exit -1
fi
}

function CHECK_NEWROOT_SET {
if [ -z "$newRoot" ] ; then
echo "newROOT path is not set ; use -r option; exit"
exit -1
fi
}


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
    -v|-ver|--version)
        setVersion $2
        shift
        shift
        ;;
    -r|-root|--root)
        setNewRoot $2
        shift
        shift
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
