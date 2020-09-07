#! /usr/bin/env bash

function uncompress {
  archivename=$1
  ext="${archivename##*.}"
  case $ext in
    zip)
      unzip -o $archivename ;;
    xz)
      xz -d $archivename ;;
    *)
      echo Unsupported extention $ext ;;
  esac
  fname="${archivename%.*}"
  if [ ${fname: -4} == ".img" ]; then
    mv $fname $IMAGE_NAME
  else
    mv $fname.img $IMAGE_NAME
  fi
}

function fetch_media {
  torrentname=`curl -I $IMAGE_TORRENT_URL | grep location: | grep -o 'http.*.torrent'`
  aria2c --seed-time=0 $torrentname
  torrentname=`basename $torrentname`
  archivename=`echo "${torrentname%.*}"`
  uncompress $archivename
  if [ -n "$QEMU_KERNEL_URL" ]; then
    mkdir kernel
    wget $QEMU_KERNEL_URL -O kernel/kernel-qemu
  fi
  rm *.torrent
}

if [[ $EUID -eq 0 ]]; then
   echo "Please do not run $0 as root"
   exit 1
fi

fetch_media
