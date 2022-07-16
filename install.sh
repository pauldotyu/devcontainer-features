#!/bin/bash
set -e

# The install.sh script is the installation entrypoint for any dev container 'features' in this repository. 
#
# The tooling will parse the devcontainer-features.json + user devcontainer, and write 
# any build-time arguments into a feature-set scoped "devcontainer-features.env"
# The author is free to source that file and use it however they would like.
set -a
. ./devcontainer-features.env
set +a

if [ ! -z ${_BUILD_ARG_AZEXTENSION} ]; then
    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>
    NAMES="${_BUILD_ARG_AZEXTENSION_NAMES}"
    
    echo "Installing Azure CLI extensions: ${NAMES}"
    names=(`echo ${NAMES} | tr ',' ' '`)
    for i in "${names[@]}"
    do
        printf "Installing ${i}\n"
        az extension add --name ${i} -y
    done
    az extension list
fi
