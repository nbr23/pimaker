#! /usr/bin/env bash

function copy_to_device {
  if [ ! -n "$TARGET_DEVICE" ]; then
    echo "TARGET_DEVICE NOT DEFINED"
    exit 1;
  fi
  echo -e "The following step will write $IMAGE_NAME to $TARGET_DEVICE. This will overwrite any data on $TARGET_DEVICE and ALL DATA WILL BE LOST.\nEnter YES to overwrite $TARGET_DEVICE"
  read -p "OVERWRITE and lose data? " yesno
  case "$yesno" in
    YES)
      dd if="$IMAGE_NAME" of="$TARGET_DEVICE" bs=4096 ;;
    *)
      echo "NOT overwritting $TARGET_DEVICE. Exiting instead."
      exit 1 ;;
  esac
}

if [[ $EUID -ne 0 ]]; then
   echo "Please run $0 as root"
   exit 1
fi

copy_to_device
