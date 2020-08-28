#! /usr/bin/env bash

function wait_pid {
  echo "Waiting for qemu process to end..."
  while pgrep -F qemu.pid >/dev/null; do
    sleep 2;
  done
}

function qemu_to_img {
  qemu-img convert $IMAGE_NAME.qcow2 $IMAGE_NAME
}

if [[ $EUID -ne 0 ]]; then
   echo "Please run $0 as root"
   exit 1
fi

wait_pid
qemu_to_img
