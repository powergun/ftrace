#!/usr/bin/env bash

function buildFtrace() {
    buildDir=/tmp/build
    rm -rf ${buildDir}; mkdir ${buildDir}
    local _pwd=$( pwd )
    cd ${buildDir}
    cmake ${_pwd}/..
    make
    cd ${_pwd}
    if [ -x ${buildDir}/src/ftrace ]
    then
        ftraceExe=${buildDir}/src/ftrace
    else
        echo "fail to build ftrace"
        exit 1
    fi
}

function buildSUT() {
    sutSrc=${buildDir}/_.c
    sutExe=${buildDir}/_
    cat > ${sutSrc} <<EOF
#include <stdio.h>
int main(int argc, char **argv) {
    printf("there is a cow\n");
    return 0;
}
EOF
    if ! ( gcc -o ${sutExe} ${sutSrc} )
    then
        echo "fail to build sut"
        exit 1
    fi
}

function traceNothing() {
    ${ftraceExe} ${sutExe}
}

buildFtrace
buildSUT
traceNothing
