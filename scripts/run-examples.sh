#!/usr/bin/env bash
source ./setup-common.sh

function run_example_tracking_mapping() {
    # run tracking and mapping
    ${OPENVSLAM_DIR}/build/run_video_slam -v ${DATA_DIR}/build/orb_vocab/orb_vocab.dbow2 \
    -m ${DATA_DIR}/build/aist_living_lab_1/video.mp4 \
    -c ${DATA_DIR}/build/aist_living_lab_1/config.yaml \
    --frame-skip 3 --no-sleep --map-db build/map.msg
    # click the [Terminate] button to close the viewer
    # you can find map.msg in the current directory
}

function run_example_localization() {
    ${OPENVSLAM_DIR}/build/run_video_localization -v ${DATA_DIR}/orb_vocab/orb_vocab.dbow2 \
    -m ${DATA_DIR}/aist_living_lab_2/video.mp4 \
    -c ${DATA_DIR}/aist_living_lab_2/config.yaml \
    --frame-skip 3 --no-sleep --map-db build/map.msg
}

function check_and_unzip() {
    file_name=$1
    ! test -d ${DATA_DIR}/build/${file_name} && unzip ${DATA_DIR}/${file_name}.zip -d ${DATA_DIR}/build
}

function check_unzip_data() {
    check_and_unzip "orb_vocab"
    check_and_unzip "aist_living_lab_1"
    check_and_unzip "aist_living_lab_2"
}

function run() {
    functions=(`get_example_functions`)
    fun_name=$1
    check_unzip_data
    for f in ${functions[*]}
    do
        if [[ "$fun_name" == "$f" ]]; then
            echo "run example: run_example_${fun_name}"
            run_example_${fun_name}
            return 0
        fi
    done

    echo "Please input the correct example: ${functions[*]},${fun_name}"
}

function get_example_functions() {
    ex_functions=(`declare -F`)
    for f_name in ${ex_functions[*]}
    do
        case ${f_name} in
        run_example_*)
           echo "${f_name:12}"
           ;;
        esac
    done
}

run $*