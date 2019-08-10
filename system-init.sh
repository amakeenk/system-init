#!/bin/bash -e

_user=amakeenk
_cur_dir=$(pwd)

[ $(whoami) != "root" ] && exit 1

echo "${_user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ln -sv /sbin/reboot /usr/bin/reboot
ln -sv /sbin/poweroff /usr/bin/poweroff

apt-get install $(cat pkglist)

mkdir -p /local_repo/x86_64/RPMS.dir
apt-repo add 'rpm-dir file:/local_repo x86_64 dir'

sed -i "/set backup/d" /etc/vim/vimrc

hasher-useradd ${_user}

sed -i "/#tmpfs/s/#//" /etc/fstab
sed -i "/home\/tmp/d" /etc/fstab

plymouth-set-default-theme bgrt
make-initrd

su - ${_user} -c "${_cur_dir}/user-settings.sh ${_user}"

echo "Reboot now? (y/n)"
read answer
[ ${answer} == y ] && reboot
