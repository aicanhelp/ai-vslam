#!/usr/bin/env bash
source ./setup-common.sh

function build_vslam() {
    cd ${OPENVSLAM_DIR}
    echo "build openvslam on `pwd`"
    ! test -e build && mkdir build
    cd build
    cmake \
        -DBUILD_WITH_MARCH_NATIVE=ON \
        -DUSE_PANGOLIN_VIEWER=OFF \
        -DUSE_SOCKET_PUBLISHER=ON \
        -DUSE_STACK_TRACE_LOGGER=ON \
        -DBOW_FRAMEWORK=DBoW2 \
        -DBUILD_TESTS=ON \
        ..
    make -j4
}

build_vslam