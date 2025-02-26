#!/bin/sh

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

"$script_dir"/setup.sh &

# Enable preview features in keycloak
exec /opt/keycloak/bin/kc.sh start-dev
