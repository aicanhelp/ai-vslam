#!/usr/bin/env bash
source ./setup-common.sh

components="mac_dependencies dbow2 g2o socketView mac_protobuf"

install_components "${components}" "$*"