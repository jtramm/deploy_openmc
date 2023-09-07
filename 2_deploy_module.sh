#!/bin/bash
#set -x

# Ensure this script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    echo "Error: you need to source this script!"
    exit 1
fi

MODFILE=./modulefiles/deployed_modulefiles/openmc/"$DEPLOY_OPENMC_VID"
echo "Creating new module file: $MODFILE"

# Copy base modulefile to modulefiles/VID
cp ./modulefiles/template_modulefiles/${BASE_MODULE} $MODFILE

# Fille in DEPLOY_OPENMC_HOME and DEPLOY_OPENMC_VID
sed -i 's@DEPLOY_OPENMC_HOME@'"$DEPLOY_OPENMC_HOME"'@g' $MODFILE
sed -i 's@DEPLOY_OPENMC_VID@'"$DEPLOY_OPENMC_VID"'@g' $MODFILE

echo "Loading new module file: openmc/$DEPLOY_OPENMC_VID"
module use openmc/"$DEPLOY_OPENMC_VID"
