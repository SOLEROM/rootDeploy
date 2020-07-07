#!/bin/bash
##set help function and call common to handle input params
helpFunc=HELP_PRINT_kernelDefi

function HELP_PRINT_kernelDefi {
echo "HELP_PRINT_kernelDefi"
echo " -f : full build the container"
echo " -u : update stage of the container"
}


function buildCont {
newRoot=$1
cd ../../deploy && sudo ./deploy_basic_x_dev.sh -r $newRoot -v 18
}

function updateCont {
newRoot=$1
cd ../../stagesBuild/
source ./common.sh
CHECK_NEWROOT_SET   
##=================================================================================##
ECHO "Running kernel-defi-build:: install deps "
#deps:
RUN_IN_CHROOT $newRoot "ls"
##=================================================================================##
}



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
    -f|-full|--full)
        buildCont $2
        updateCont $2 
        shift
        shift
	exit 1
        ;;
    -u|-update|--update)
        updateCont $2 
        shift 
        shift 
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

