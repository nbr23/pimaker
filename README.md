# pimaker

Simple qemu and ansible powered set of scripts to build and configure raspios images.

## Summary
Scripts collection to modify the raspios image:

- mounts the image to perform some initial modifications
- boots on it using qemu
- runs ansible playbooks through qemu
- converts the qemu image back to .img format
- writes the image to the device/sdcard (using `dd`)

## Requirements
- ansible
- qemu


## Related links
- [ansible-role-security](https://github.com/geerlingguy/ansible-role-security): source for the ssh and auto-updates tasks
- [qemu-rpi-kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel): raspi kernel modified to boot on qemu (used for the online customization)
- [raspberry linux kernel](https://github.com/raspberrypi/linux/)
- [raspios](https://www.raspberrypi.org/downloads/raspberry-pi-os/)

## Usage

### pimaker all
Full build: download latest media, apply changed, and flash to SD Card

### pimaker download
Download latest media and requirement qemu kernel

### pimaker edit-offline
Mount the .img and perform offline customizations to the OS:

- Enable ssh on boot
- Rename `pi` user to `$IMAGE_USER`
- Add public key located at `$SSH_PUBKEY` to `$IMAGE_USER`'s authorized keys

### pimaker img2qemu
Convert .img file to qemu image

### pimaker run
Boots the image on qemu

### pimaker ansible
Runs `$ANSIBLE_PLAYS` playbook list on the qemu booted image

### pimaker qemu2img
Converts back qemu image to .img

### pimaker img2device
Flashes `$IMAGE_NAME` to `$TARGET_DEVICE`

### pimaker clean
Deletes all temporary and intermediate files

## Configuration
`pimaker` configuration is performed through the environment variables in `config.env`:

- `IMAGE_NAME`: name for the target .img file to create
- `IMAGE_USER`: name of the main user to replace the stock `pi` user
- `IMAGE_SIZE`: size of the target device. If `$TARGET_DEVICE` is defined then the size will be discovered automatically
- `SSH_PUBKEY`: path to the ssh public key to add to `$IMAGE_USER`'s `authorized_keys` file
- `QEMU_SSH_PORT`: local port to map to qemu's port 22 (used for `ansible` to connect to the image and run playbooks
- `TARGET_DEVICE`: path to the device on the host OS. If defined, will be used to find `$IMAGE_SIZE` and `pimaker` will flash the created img to this device using `dd`
