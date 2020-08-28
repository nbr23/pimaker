#! /usr/bin/env bash

function fetch_media {
  torrentname=`curl -I https://downloads.raspberrypi.org/raspios_lite_armhf_latest.torrent | grep location: | grep -o 'http.*.torrent'`
  aria2c --seed-time=0 $torrentname
  torrentname=`basename $torrentname`
  zipname=`echo "${torrentname%.*}"`
  unzip -o $zipname
  imagename=`echo "${zipname%.*}.img"`
  mv $imagename $IMAGE_NAME
  mkdir kernel
  wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie -O kernel/kernel-qemu
  rm *.torrent
}

if [[ $EUID -eq 0 ]]; then
   echo "Please do not run $0 as root"
   exit 1
fi

fetch_media
