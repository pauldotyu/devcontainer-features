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
    echo "Installing Azure CLI extensions: ${_BUILD_ARG_AZEXTENSION_NAMES}"
    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>

    IFS=',' read -ra my_array <<< "$_BUILD_ARG_AZEXTENSION_NAMES"

    tee /usr/azextension.sh > /dev/null \
    << EOF
    #!/bin/bash
    for i in "${my_array[@]}"
    do
      echo "Installing $i"
      az extension add --name ${i} -y
    done
    
    az extension list
EOF

    chmod +x /usr/azextension.sh
    sudo cat '/usr/azextension.sh' > /usr/local/bin/azextension
    sudo chmod +x /usr/local/bin/azextension
fi
