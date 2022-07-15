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
    echo "Installing Azure CLI extension"

    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>
    NAME=${_BUILD_ARG_AZEXTENSION_NAME:-undefined}

    tee /usr/azextension.sh > /dev/null \
    << EOF
    #!/bin/bash
    az extension add --name ${NAME} -y
EOF

    chmod +x /usr/azextension.sh
    sudo cat '/usr/azextension.sh' > /usr/local/bin/azextension
    sudo chmod +x /usr/local/bin/azextension
fi
