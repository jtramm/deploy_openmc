#!/bin/bash

# User sets this parameter to be the modulefile in the
# modulefiles/template/modulefiles directory that they want to use
# to base their environment off of. Recommend to copy one of the files
# into a new file, customize it, and then point this variable to their
# new customized modulefile
export BASE_MODULE=generic_a100

# Determine module/install version number
DEPLOY_OPENMC_VID=$(date +"%Y.%m.%d")
PREV_INSTALLS=$(find installs -type d -name ${DEPLOY_OPENMC_VID}* | wc -l)
DEPLOY_OPENMC_VID+="."
DEPLOY_OPENMC_VID+=$PREV_INSTALLS
echo $DEPLOY_OPENMC_VID
export DEPLOY_OPENMC_HOME=/home/jtramm/deploy_openmc
module use ${DEPLOY_OPENMC_HOME}/deployed_modulefiles
