#! /usr/bin/env bash

function enable_ssh_on_boot {
  offset=`fdisk -l $IMAGE_NAME | grep FAT32 | awk '{ print $2 }'`
  mkdir mnt
  mount -o loop,offset=$((offset * 512)) $IMAGE_NAME mnt/
  touch mnt/ssh
  umount mnt
}

function mount_image {
  offset=`fdisk -l $IMAGE_NAME | grep Linux | awk '{ print $2 }'`
  mkdir mnt
  mount -o loop,offset=$((offset * 512)) $IMAGE_NAME mnt/
}

function get_pi_uid {
  cat mnt/etc/passwd | grep ^pi: | cut -d':' -f 3
}

function add_ssh_pub_key {
  mkdir -p mnt/home/pi/.ssh/
  cp $SSH_PUBKEY mnt/home/pi/.ssh/authorized_keys
  chmod 644 mnt/home/pi/.ssh/authorized_keys
  uid=`get_pi_uid`
  chown -R $uid mnt/home/pi/.ssh/
}

function umount_image {
  umount mnt
}

function rename_user {
  cp mnt/etc/passwd mnt/etc/passwd.bak
  grep -v "^pi:" mnt/etc/passwd.bak > mnt/etc/passwd
  echo "$IMAGE_USER:x:1000:1000:,,,:/home/$IMAGE_USER:/bin/bash" >> mnt/etc/passwd
  rm mnt/etc/passwd.bak

  cp mnt/etc/group mnt/etc/group.bak
  grep -v "^pi:" mnt/etc/group.bak | sed "s/:pi$/:$IMAGE_USER/g"> mnt/etc/group
  echo "$IMAGE_USER:x:1000:" >> mnt/etc/group
  rm mnt/etc/group.bak

  cp mnt/etc/shadow mnt/etc/shadow.bak
  sed "s/^pi:/$IMAGE_USER:/g" mnt/etc/shadow.bak > mnt/etc/shadow
  rm mnt/etc/shadow.bak

  echo "$IMAGE_USER:100000:65536" > mnt/etc/subgid
  echo "$IMAGE_USER:100000:65536" > mnt/etc/subuid

  mv mnt/home/pi mnt/home/$IMAGE_USER
  sed "s/^pi/$IMAGE_USER/g" mnt/etc/sudoers.d/010_pi-nopasswd > mnt/etc/sudoers.d/010_$IMAGE_USER-nopasswd
  rm mnt/etc/sudoers.d/010_pi-nopasswd
}

if [[ $EUID -ne 0 ]]; then
   echo "Please run $0 as root"
   exit 1
fi

enable_ssh_on_boot
mount_image
add_ssh_pub_key
rename_user
umount_image
