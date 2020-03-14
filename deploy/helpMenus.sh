#help menus


function ROOT_OPTIONS_PRINT {
echo "=========================================="
echo "ROOT_OPTIONS:"
echo "--ubu_64_16       ubuntu x86 16.04"
echo "=========================================="
}


function HELP_PRINT_STAGE01 {
echo "==================================================="
echo "stage01.sh Help Menu:"
echo "Usage:"
echo "./stage01.sh  -h|-help|--help             Show this menu"
echo "./stage01.sh  -o|-options|--options       Show rootFS build options"
echo "Run:"
echo "./stage01.sh  <newFolderPath for newRootfs> "
echo "==================================================="
exit 1
}

function HELP_PRINT_STAGE02 {
echo "==================================================="
echo "stage02.sh Help Menu:"
echo "Usage:"
echo "./stage02.sh  -h|-help|--help     	Show this menu"
echo "Run:"
echo "./stage02.sh  <newFolderPath for newRootfs> "
echo "==================================================="
exit 1
}

function HELP_PRINT_STAGE03 {
echo "==================================================="
echo "stage03.sh Help Menu:"
echo "Usage:"
echo "./stage03.sh  -h|-help|--help             Show this menu"
echo "Run:"
echo "./stage03.sh  <newFolderPath for newRootfs> "
echo "==================================================="
exit 1
}


function HELP_PRINT_STAGE04 {
echo "==================================================="
echo "stage04.sh Help Menu:"
echo "Usage:"
echo "./stage04.sh  -h|-help|--help             Show this menu"
echo "Run:"
echo "./stage04.sh  <newFolderPath for newRootfs> "
echo "==================================================="
exit 1
}



# help
function HELP_PRINT_xEnable {
echo "==================================================="
echo "Help Menu:"
echo "stage_xEnable.sh will make the rootfs abale to run X Gui staff"
echo "Flags:"
echo "./stage_xEnable.sh -h|-help|--help             Show this menu"
echo "Usage:"
echo "stage_xEnable.sh  <FolderPath for newRootfs> "
echo "==================================================="
exit 1
}
