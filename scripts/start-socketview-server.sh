#!/usr/bin/env bash

source ./setup-common.sh

function setup_server() {
    $ cd ${OPENVSLAM_DIR}/viewer
    $ npm install
}

function start_server() {
    $ cd ${OPENVSLAM_DIR}/viewer
    $ node app.js
}

function start() {
    setup_server
    start_server
}

start