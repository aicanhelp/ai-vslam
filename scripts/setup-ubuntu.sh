#!/usr/bin/env bash
source ./setup-common.sh

components="ubuntu_dependencies eigen dbow2 g2o socketView ubuntu_protobuf"

install_components "${components}" "$*"
