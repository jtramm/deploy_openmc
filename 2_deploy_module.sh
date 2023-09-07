#!/bin/bash

# Copy build/install directory to install/VID
cp -r ./code/openmc/build/install ./installs/${DEPLOY_OPENMC_VID}

# Copy base modulefile to modulefiles/VID
cp ./modulefiles/template_modulefiles/${BASE_MODULE} ./modulefiles/deployed_modulefiles/${DEPLOY_OPENMC_VID}
