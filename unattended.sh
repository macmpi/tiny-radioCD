#!/bin/sh

# Part of tiny-radioCD project, originally designed & hand-crafted by macmpi
# check License at project home https://github.com/macmpi/tiny-radioCD


### unattended script for use in alpine-linux-headless-bootstrap
# https://github.com/macmpi/alpine-linux-headless-bootstrap
# Builds tiny-radioCD diskless base image on target platform.
# Resulting install is ready to use on actual media.
# A generic image (tar archive) is also available on /tmp

BRANCH="master"
GENERIC=false

###  Prep environment
logger -st ${0##*/} "Setting-up minimal environment"

cd /tmp

cat <<-EOF > ANSWERFILE
	# base answer file for setup-alpine script
	# minimal to setup tiny-radioCD in diskless mode

	# Do not set keyboard layout
	KEYMAPOPTS=none

	# Keep hostname
	HOSTNAMEOPTS="$(hostname)"

	# Set device manager to mdev
	DEVDOPTS=mdev

	# Contents of /etc/network/interfaces
	INTERFACESOPTS=none

	# Set Public nameserver
	DNSOPTS="-n 208.67.222.222"

	# Set timezone to UTC
	TIMEZONEOPTS="UTC"

	# set http/ftp proxy
	PROXYOPTS=none

	# Add first mirror (CDN)
	APKREPOSOPTS="-1"

	# Do not create any user
	USEROPTS=none

	# Install Openssh
	SSHDOPTS=none

	# Use openntpd
	NTPOPTS="chrony"

	# No disk install (diskless)
	DISKOPTS=none

	# Setup storage for diskless (find boot directory in /media/xxxx/apk/.boot_repository)
	LBUOPTS="$( find /media -maxdepth 3 -type d -path '*/.*' -prune -o -type f -name '.boot_repository' -exec dirname {} \; | head -1 | xargs dirname )"
	APKCACHEOPTS="\$LBUOPTS/cache"

	EOF

# trick setup-alpine to assume existing SSH connection and therefore not reset interfaces
SSH_CONNECTION="FAKE" setup-alpine -ef ANSWERFILE

. /etc/lbu/lbu.conf
BOOTPATH="/media/$LBU_MEDIA"

logger -st ${0##*/} "Getting tiny-radioCD tarball"
url="https://github.com/macmpi/tiny-radioCD/archive/$BRANCH.zip"

wget -O tiny-radioCD.zip "$url"
unzip -oq tiny-radioCD.zip > /tmp/mkimage.log 2>&1
rm tiny-radioCD.zip
cd tiny-radioCD*
chmod +x mkimage

###  Building tiny-radioCD image
logger -st ${0##*/} "Setting-up tiny-radioCD (takes time)..."
./mkimage >> /tmp/mkimage.log 2>&1


###  Wrapping-up & archiving generic image if needed
logger -st ${0##*/} "Wrapping-up..."

# On Pi, eventually disable dtoverlay=dwc2 inherited from headless setup
if grep -q "Raspberry Pi" /proc/cpuinfo; then
	mount -o remount,rw $BOOTPATH
	sed -i 's/^dtoverlay=dwc2/#dtoverlay=dwc2/' $BOOTPATH/usercfg.txt
	sed -i 's/^dtoverlay=dwc2/#dtoverlay=dwc2/' $BOOTPATH/config.txt
	sync
	mount -o remount,ro $BOOTPATH
fi

# diskless: do not reveal in distributed image & is regenerated at boot by dbus post-install
rm /etc/machine-id

if $GENERIC; then
	logger -st ${0##*/} "Archiving generic image in /tmp (takes time)..."

	# impersonate /etc/fstab entry to not depend on UUID for generic image
	cp /etc/fstab /tmp/.
	DEV="$( grep $BOOTPATH /proc/mounts | awk '{print $1}' )"
	sed -i "s|^.*$BOOTPATH|$DEV\t$BOOTPATH|" /etc/fstab

	lbu commit -d

	# Archiving generic image
	# for low RAM devices (512K) increase available RAM in rootfs to store compressed image
	SIZE="$( df | grep '^tmpfs.*\/$' | awk '{printf $2}' )"
	if [ "$SIZE" -lt "368640" ]; then
		mount -o remount,size=70M /dev/shm
		mount -o remount,size=360M /
	fi
	
	cd "$BOOTPATH"
	find . -type d -path '*/.*' -prune -o \
		-type f -path './unattended.sh' -prune -o \
		-type f -path './interfaces' -prune -o \
		-type f -path './wpa_supplicant.conf' -prune -o \
		-type f -print0 | \
			xargs -0 tar -czf /tmp/image_"$(uname -m)".tgz

	# Restore /etc/fstab for local machine eventual use
	mv /tmp/fstab /etc/fstab
	lbu commit -d

	# add scp so that image can be downloaded over ssh
	echo "nameserver 208.67.222.222" > /etc/resolv.conf
	apk add openssh openssh-client-common

	logger -st ${0##*/} "generic image available via scp as /tmp/image_$(uname -m).tgz !!"

else
	lbu commit -d
fi

logger -st ${0##*/} "Finished tiny-radioCD setup !!"

