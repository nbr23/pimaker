#! /usr/bin/env bash

function image_to_qemu {
  rm -f $IMAGE_NAME.qcow2
  qemu-img resize -f raw $IMAGE_NAME $IMAGE_SIZE
  parted $IMAGE_NAME resizepart 2 100%
  qemu-img convert -f raw -O qcow2 $IMAGE_NAME $IMAGE_NAME.qcow2
  rm $IMAGE_NAME
}

if [[ $EUID -eq 0 ]]; then
   echo "Please do not run $0 as root"
   exit 1
fi

image_to_qemu
