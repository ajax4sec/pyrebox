#!/bin/bash

#This script is provided as an example of a possible QEMU / Pyrebox configuration
#for a Windows XP SP3, 32 bit analysis target.

#It assumes that pyrebox.conf.WinXPSP3x86 exists, and contains the list
#of scripts to be loaded on startup, as well as the configuration parameter
#that indicates Volatility the profile to apply.

#The QEMU parameters specified will start a VM with:
#   * 256 MiB of RAM
#   * Usb support
#   * A main hard-drive, provided as a qcow2 image as the first parameter for the script
#   * Starts a VNC server on 127.0.0.1 for showing the system display
#   * Redirects the QEMU monitor to stdio (only configuration supported currently)

ARGV=($(getopt -o c:i:s: -- "$@"))
for((i = 0; i < ${#ARGV[@]}; i++)) {
    eval opt=${ARGV[$i]}
    case $opt in
        -c)
            ((i++));
            eval confile=${ARGV[$i]}
            ;;
        -i)
            ((i++));
            eval imgfile=${ARGV[$i]}
            ;;
        -s)
            ((i++));
            eval snapfile=${ARGV[$i]}
            ;;    
        --)
            break
            ;;
    esac
}
echo "confile  : "${confile}
echo "imgfile  : "${imgfile}
echo "snapfile : "${snapfile}

# set configure file
if [ -n "${confile}" ]
then
    cp ${confile} /home/xxj56/git/pyrebox_ajax/pyrebox.conf
fi

# start cmd
####### cmd from origin pyrebox 
#./pyrebox-i386 -monitor stdio -m 256 -usb -usbdevice tablet -drive file=$1,index=0,media=disk,format=qcow2,cache=unsafe -vnc 127.0.0.1:0 ${snapshot}

####### cmd 
/home/xxj56/git/pyrebox_ajax/pyrebox-i386 -monitor stdio -m 1024 -net none -device qemu-xhci,id=xhci -device usb-tablet,bus=xhci.0 -drive file=${imgfile},index=0,media=disk,format=qcow2,cache=unsafe -incoming "exec: gzip -c -d ${snapfile}" -snapshot
