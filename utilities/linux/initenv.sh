#!/usr/bin/env bash

typeset reset="\033[0;0;0m"
typeset wobnb="\033[0;37;44m"
typeset wob="\033[1;37;44m"
typeset wog="\033[1;37;40m"
typeset worb="\033[1;37;41m"
typeset rowb="\033[1;31;47m"
typeset wor="\033[0;37;41m"
typeset row="\033[0;31;47m"
typeset s="> /dev/null"
typeset ss="2>&1 >/dev/null"

x() {
    typeset cmnd="$1"
	typeset msg="$2"
    typeset ret_code
	if [[ $# -eq 2 ]]; then
		echo -en "${wob} $msg "
	fi
    eval $cmnd
    ret_code=$?
    if [[ $ret_code != 0 ]]; then
            err "task returned ${ret_code}, expected 0"
    else
		if [[ $# -eq 2 ]]; then
            success " okay "
		fi
    fi
                
}

err() {
    typeset err="$*"
    echo -e "\033[1;37;41mfatal:\033[0;37;41m ${err}${reset}"
    exit 1
}

success() {
    typeset msg="$*"
    echo -e "\033[1;37;42m ${msg} ${reset}"
}

echo "Initialising enviroment for Theta building."
x "g++ utilities/gitcommit.cpp -o utilities/linux/gitcommit" "Compiling gitcommit   "
x "gcc utilities/acsconstants.c -o utilities/linux/acsconstants" "Compiling acsconstants"
x "g++ utilities/acschangelog.cpp -o utilities/linux/acschangelog" "Compiling acschangelog"
x "cd utilities/linux"
if [[ -d "bcc" || -f "bcc" ]]; then
	x "rm -rf bcc ${ss}"
fi
x "git clone -q https://github.com/wormt/bcc ${s}" "Cloning bcc           "
x "cd bcc"
x "premake4 gmake ${s}" "Generating makefiles  "
x "make -j12 ${s}" "Compiling bcc         "
x "mv bcc ../acc.tmp"
x "mv include/*.acs .."
x "cd .."
x "rm -rf acc" "Removing bcc directory"
x "mv acc.tmp acc"

echo
success "You should now have a working Theta build enviroment"
success "          You may now run the build script          "

