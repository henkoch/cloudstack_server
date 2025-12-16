#!/usr/bin/env bash
set -o errexit
set -o pipefail

# This script will download the Ubuntu cloud image for Jammy
#   and then copy in the netplan for nic0 called 'eth0'.

# original: https://gist.github.com/nkabir/71bf64e45013dcd965374fdaec95613d

# sudo apt install guestfs-tools

readonly KVM_IMAGE_DESTINATION_DIRECTORY="/var"
readonly VIRTBUILDER_NAME="centos7"
readonly IMAGE_NAME="CentOS-7-x86_64-GenericCloud"
readonly KVM_IMAGE_FORMAT="qcow2"

# export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
# copy downloaded cloud img to qcow2
cp "/home/hck/Downloads/${IMAGE_NAME:?}.${KVM_IMAGE_FORMAT:?}" "${KVM_IMAGE_DESTINATION_DIRECTORY:?}"

# absolute path to virtbuilder file
readonly VB_FA="${KVM_IMAGE_DESTINATION_DIRECTORY:?}/${IMAGE_NAME:?}.${KVM_IMAGE_FORMAT:?}"


# bug in cloud image
# https://bugs.launchpad.net/cloud-images/+bug/1573095

#    --ssh-inject "root:file:$HOME/.ssh/id_rsa.pub" \
#    --copy-in build/01-netcfg.yaml:/etc/netplan \
#    --root-password "file:${HOME}/.ssh/base_image.password" \

#    --run-command "sed -i 's/ console=ttyS0//g' /etc/default/grub.d/50-cloudimg-settings.cfg" \
#    --run-command "update-grub" \
#    --copy-in ./01-netcfg.yaml:/etc/netplan \
#    --run-command "systemctl mask apt-daily.service apt-daily-upgrade.service" \
#    --firstboot-command "netplan generate && netplan apply" \
#    --firstboot-command "dpkg-reconfigure openssh-server" \

# generates <name>-vb.qcow2
virt-customize \
    --format "${KVM_IMAGE_FORMAT:?}" \
    --no-network \
    --hostname "${VIRTBUILDER_NAME:?}" \
    --root-password "password:SECRET" \
    --run-command "sed -i 's/GRUB_CMDLINE_LINUX/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0 console=tty1\"/g' /etc/default/grub" \
    --run-command "sed -i 's/ibm-p8-kvm-03-guest-02.virt.pnr.lab.eng.rdu2.redhat.com//g' /etc/hosts" \
    --firstboot-command "sync" \
    -a "${VB_FA:?}"

# See: https://github.com/dmacvicar/terraform-provider-libvirt/issues/357
#sudo qemu-img resize ${VB_FA:?} 10G