#!/bin/bash

echo "Installing OpenMC to ./installs/$DEPLOY_OPENMC_VID"

# Copy build/install directory to install/VID
cp -r ./code/openmc/build/install ./installs/${DEPLOY_OPENMC_VID}
