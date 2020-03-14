## common bash script help script

function ROOT_OPTIONS_PRINT {
echo "=========================================="
echo "ROOT_OPTIONS:"
echo "--ubu_64_16	ubuntu x86 16.04" 
echo "=========================================="
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
