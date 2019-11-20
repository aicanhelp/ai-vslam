#!/usr/bin/env bash
source ./setup-common.sh

components="mac_dependencies dbow2 g2o PangolinView socketView mac_protobuf"
slambook_components="sophus gstam"

install_components "${components} ${slambook_components}" "$*"