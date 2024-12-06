#!/bin/bash

# create new qcow2 image
qemu-img create -f qcow2 encryptedImage.qcow2 30G

# copy the OVMF_VARS.fd file
cp /usr/share/OVMF/OVMF_VARS.fd OVMF_VARS.fd 

qemu-system-x86_64 \
-enable-kvm \
-cpu EPYC \
-machine q35 \
-no-reboot \
-vga std \
-vnc :0
-drive file=distro.iso=cdrom -boot d \
-drive if=pflash,format=raw,unit=0,file=/usr/share/OVMF/OVMF_CODE.fd,readonly=on \
-drive if=pflash,format=raw,unit=1,file=OVMF_VARS.fd \
-drive file=encryptedImage.qcow2,if=none,id=disk0,format=qcow2
-device virtio-scsi-pci,id=scsi0,disable-legacy=on,iommu_platform=on
-device scsi-hd,drive=disk0
-machine memory-encryption=sev0,vmport=off
-object sev-guest,id=sev0,policy=0x3,cbitpos=47,reduced-phys-bits=1