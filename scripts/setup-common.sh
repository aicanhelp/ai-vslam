#!/usr/bin/env bash

CUR_DIR=`pwd`
trap "cd ${CUR_DIR}" 2 3 4 9 15
#set -x -u -e
WORK_DIR=${CUR_DIR}/build
OPENVSLAM_DIR=../openvslam
DATA_DIR=../data/build
! test -e ${WORK_DIR} && mkdir ${WORK_DIR}

function install_dbow2() {
    cd ${WORK_DIR}
    git clone https://github.com/shinsumicco/DBoW2.git
    cd DBoW2
    mkdir build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        ..
    make -j4
    make install
    cd ..
}

function install_g2o() {
    cd ${WORK_DIR}
    git clone https://github.com/RainerKuemmerle/g2o.git
    cd g2o
    git checkout 9b41a4ea5ade8e1250b9c1b279f3a9c098811b5a
    mkdir build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_CXX_FLAGS=-std=c++11 \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_UNITTESTS=OFF \
        -DBUILD_WITH_MARCH_NATIVE=ON \
        -DG2O_USE_CHOLMOD=ON \
        -DG2O_USE_CSPARSE=ON \
        -DG2O_USE_OPENGL=OFF \
        -DG2O_USE_OPENMP=ON \
        ..
    make -j4
    make install
    cd ..
}

function install_PangolinView() {
    cd ${WORK_DIR}
    git clone https://github.com/stevenlovegrove/Pangolin.git
    cd Pangolin
    git checkout ad8b5f83222291c51b4800d5a5873b0e90a0cf81
    mkdir build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        ..
    make -j4
    make install
    cd ..
}

function install_socketView() {
    cd ${WORK_DIR}
    git clone https://github.com/shinsumicco/socket.io-client-cpp
    cd socket.io-client-cpp
    git submodule init
    git submodule update
    mkdir build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DBUILD_UNIT_TESTS=OFF ..
    make -j4
    make install
    cd ..
}

function install_components() {
    components=($1)
    com=($2)
    echo "try to install component [${com}] of components: ${components[*]}"

    for c1 in ${com}
    do
        for c2 in ${components[*]}
        do
            if [[ "$c1" == "$c2" || "$c1" == "all" ]]; then
                echo "install $c2"
                install_$c2
                return 0
            fi
        done
    done

    echo "please input the parameter: $0 ${components[*]}"
}

function install_macos_protobuf() {
    brew install protobuf
}

function install_dependencies() {
    # brew update
    # basic dependencies
    brew install pkg-config cmake git
    # g2o dependencies
    brew install suite-sparse
    # OpenCV dependencies and OpenCV
    brew install eigen
    brew install ffmpeg
    brew install opencv
    # other dependencies
    brew install yaml-cpp glog gflags

    # (if you plan on using PangolinViewer)
    # Pangolin dependencies
    brew install glew

    # (if you plan on using SocketViewer)
    # Protobuf dependencies
    brew install automake autoconf libtool
    # Node.js
    brew install node
}

function install_mac_protobuf() {
    brew install protobuf
}

function install_ubuntu_dependencies() {
    apt update -y
    apt upgrade -y --no-install-recommends
    # basic dependencies
    apt install -y build-essential pkg-config cmake git wget curl unzip
    # g2o dependencies
    apt install -y libatlas-base-dev libsuitesparse-dev
    # OpenCV dependencies
    apt install -y libgtk-3-dev
    apt install -y ffmpeg
    apt install -y libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev
    # other dependencies
    apt install -y libyaml-cpp-dev libgoogle-glog-dev libgflags-dev

    # (if you plan on using PangolinViewer)
    # Pangolin dependencies
    apt install -y libglew-dev

    # (if you plan on using SocketViewer)
    # Protobuf dependencies
    apt install -y autogen autoconf libtool
    # Node.js
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt install -y nodejs
}

function install_eigen() {
    cd ${WORK_DIR}
    wget -q http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2
    tar xf 3.3.4.tar.bz2
    rm -rf 3.3.4.tar.bz2
    cd eigen-eigen-5a0156e40feb
    mkdir -p build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        ..
    make -j4
    make install
    cd ..
}

function install_opencv3.4() {
    cd ${WORK_DIR}
    wget -q https://github.com/opencv/opencv/archive/3.4.0.zip
    unzip -q 3.4.0.zip
    rm -rf 3.4.0.zip
    cd opencv-3.4.0
    mkdir -p build && cd build
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DENABLE_CXX11=ON \
        -DBUILD_DOCS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_OPENEXR=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_TESTS=OFF \
        -DWITH_EIGEN=ON \
        -DWITH_FFMPEG=ON \
        -DWITH_OPENMP=ON \
        ..
    make -j4
    make install
}

function install_ubuntu_protobuf() {
    apt install -y libprotobuf-dev protobuf-compiler
}