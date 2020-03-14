#!/bin/bash
source ./common.sh

# help
function HELP_PRINT {
echo "==================================================="
echo "stage01.sh Help Menu:"
echo "Usage:"
echo "./stage01.sh  -h|-help|--help     	Show this menu"
echo "./stage01.sh  -o|-options|--options	Show rootFS build options"
echo "Run:"
echo "./stage01.sh  <newFolderPath for newRootfs> "
echo "==================================================="
exit 1
}

# input flags
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -h|-help|--help) 	
	HELP_PRINT
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


# check input
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
newRoot=$1
mkdir -p $newRoot


##=================================================================================##
##=================================================================================##



##ubu1604
sudo debootstrap --arch=amd64 xenial $newRoot http://archive.ubuntu.com/ubuntu/


