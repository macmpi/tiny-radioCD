#!/bin/sh

# Part of tiny-radioCD project, originally designed & hand-crafted by macmpi
# check License at project home https://github.com/macmpi/tiny-radioCD


### unattended script for use in alpine-linux-headless-bootstrap
# https://github.com/macmpi/alpine-linux-headless-bootstrap
# Builds tiny-radioCD diskless base image on target platform.
# Resulting install is ready to use on actual media.
# A generic image (tar archive) is also available on /tmp

BRANCH="master"

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
	INTERFACESOPTS="$(cat /etc/network/interfaces)"

	# Set Public nameserver
	DNSOPTS="-n 208.67.222.222"

	# Set timezone to UTC
	TIMEZONEOPTS="UTC"

	# set http/ftp proxy
	PROXYOPTS=none

	# Add first mirror (CDN)
	APKREPOSOPTS="-1"

	# Create admin user
	# dirty workaround to not create any user
	USEROPTS=-h

	# Install Openssh
	SSHDOPTS=none

	# Use openntpd
	NTPOPTS="chrony"

	# No disk install (diskless)
	DISKOPTS=none

	# Setup storage for diskless
	#LBUOPTS="LABEL=APKOVL"
	LBUOPTS="$( find /media -type d -path '*/.*' -prune -o -type f -name *.apkovl.tar.gz -exec dirname {} \; | head -1 )"

	#APKCACHEOPTS="/media/LABEL=APKOVL/cache"
	APKCACHEOPTS="\$LBUOPTS/cache"

	EOF

setup-alpine -ef ANSWERFILE

# for low RAM devices (512K) increase available RAM in rootfs to store compressed image
SIZE="$( df | grep '^tmpfs.*\/$' | awk '{printf $2}' )"
[ "$SIZE" -lt "337920" ] && mount -o remount,size=330M /


logger -st ${0##*/} "Getting tiny-radioCD tarball"
url="https://github.com/macmpi/tiny-radioCD/archive/$BRANCH.zip"

wget -O tiny-radioCD.zip "$url"
unzip -oq tiny-radioCD.zip > /tmp/mkimage.log 2>&1
cd tiny-radioCD*
chmod +x mkimage


###  Building tiny-radioCD image
logger -st ${0##*/} "Setting-up tiny-radioCD (takes time)..."
./mkimage >> /tmp/mkimage.log 2>&1


###  Wrapping-up & archiving generic image
logger -st ${0##*/} "Fine-tuning and archiving generic image in /tmp (takes time)..."
. /etc/lbu/lbu.conf
OVLPATH="/media/$LBU_MEDIA"

# impersonate /etc/fstab entry to not depend on UUID for generic image
cp /etc/fstab /tmp/.
DEV="$( grep $OVLPATH /proc/mounts | awk '{print $1}' )"
sed -i "s|^.*$OVLPATH|$DEV\t$OVLPATH|" /etc/fstab

lbu commit -d

# On Pi, eventually disable dtoverlay=dwc2 inherited from headless setup
if grep -q "Raspberry Pi" /proc/cpuinfo; then
	mount -o remount,rw $OVLPATH
	sed -i 's/^dtoverlay=dwc2/#dtoverlay=dwc2/' $OVLPATH/usercfg.txt
	sed -i 's/^dtoverlay=dwc2/#dtoverlay=dwc2/' $OVLPATH/config.txt
	sync
	mount -o remount,ro $OVLPATH
fi

# Archiving generic image
#cd /tmp
#tar -czf image_"$(uname -m)".tgz -C $OVLPATH \
#--exclude='./unattended.sh' \
#--exclude='./interfaces' \
#--exclude='./wpa_supplicant.conf' \
#.
cd "$OVLPATH"
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
apk add openssh-client-common

logger -st ${0##*/} "Finished: generic image available via scp as /tmp/image_$(uname -m).tgz !!"

