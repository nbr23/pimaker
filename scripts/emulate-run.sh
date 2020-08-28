#! /usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
   echo "Please do not run $0 as root"
   exit 1
fi

qemu-system-arm \
        -kernel kernel/kernel-qemu \
        -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
        -hda $IMAGE_NAME.qcow2 \
        -cpu arm1176 \
        -m 256 \
        -no-reboot \
        -machine versatilepb \
        -daemonize \
        -pidfile qemu.pid\
        -nic user,hostfwd=tcp::$QEMU_SSH_PORT-:22
