#!/bin/bash -e

_user=$1

[ -z ${_user} ] && echo "usage: $0 [user]" && exit 1
[ $(whoami) != "root" ] && echo "This script must be run under root user" && exit 1

echo "${_user} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/${_user}
echo "set completion-ignore-case on" >>/etc/inputrc

apt-get remove -D $(cat pkglist-for-remove)
apt-get update
apt-get dist-upgrade
update-kernel -t un-def
apt-get install $(cat pkglist)
while true
do
    _pkglist=$(apt-cache list-nodeps | egrep "devel|^lib[^-]*$|python|perl-")
    if [ -z "${_pkglist}" ]
    then
        break
    else
        apt-get remove -D ${_pkglist}
    fi
done

mkdir -p /local_repo/x86_64/RPMS.dir
chown -R ${_user}:${_user} /local_repo
apt-repo add 'rpm-dir file:/local_repo x86_64 dir'

sed -i "/set backup/d" /etc/vim/vimrc

hasher-useradd ${_user}

sed -i "/#tmpfs/s/#//" /etc/fstab
sed -i "/home\/tmp/d" /etc/fstab

echo "Reboot now? (y/n)"
read _answer
[ ${_answer} == "y" ] && reboot
