#!/bin/bash

# Ensure this script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
    echo "Error: you need to source this script!"
    exit 1
fi

echo "Adding modulefile \"./modulefiles/deployed_modulefiles\" to list of modules"

module use ./modulefiles/deployed_modulefiles
