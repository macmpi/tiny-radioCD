# tiny-radioCD
 A small-footprint radioCD player, for Bluetooth speakers, headphones, car-audio systems,...

This personal project is geared towards simple & essential use-cases for casual listeners using Bluetooth speakers, and missing their good-old Audio CDs playback...

Check-out our minimalistic USB-powered [PiZeroWed-Mac mini](https://github.com/macmpi/tiny-radioCD/wiki/PiZeroWed-Mac-mini) !

## Main Features:

- Audio-CD & web radio player

- Sound output to any Bluetooth audio equipment, and available default audio port (can be HiFi DAC)

- Simple remote control via Bluetooth keys and/or network mpc client

- Focus on ease of use & efficiency under low memory & hardware requirements (based on [AlpineLinux](https://www.alpinelinux.org/))

- Headless operation, one-touch update


**tiny-radioCD** just relies on [MPD](https://www.musicpd.org/), ALSA and [bluez-alsa](https://github.com/Arkq/bluez-alsa/): it does not need to provide a graphical remote UI.\
Typically runs in about 30MB of RAM on a low-cost PiZero device (125 MB rootf suitable for RAM-only operation).

Though mostly tested on Pi & x86/64, it would run on any AlpineLinux supported platform (diskless/data/sys modes).\
Some ready-to-use images are available (Raspberry Pi armhf ram-only SD archive for instance).\
Customized setup can be included as simple addon-scripts (refer to available Pi example).



## Seamless user operation:

Player control (play/pause/etc...) is naturally operated with bluetooth speaker/headphone ***built-in keys***.
Volume adjustment is set by speaker amplification stage.

***Multimedia bluetooth remotes*** are a perfect match too, allowing extended use-cases.\
Typically, the low-cost first-generation ***FireTV remote*** (& clone) works great (more info in [Wiki](https://github.com/macmpi/tiny-radioCD/wiki)).\
***USB Keyboards*** with multimedia keys are supported too.

With network availability, any ***mpc client application*** can easily connect to **tiny-radioCD** player with Avahi discovery, and provide convenient user interface.\
***MaximumMPD*** on [iOS](https://itunes.apple.com/gb/app/maximummpd/id1437096437?mt=8) or Android is a good example of such client, but there are many other available on any platforms.

***Hardware buttons*** (power on/off, eject) availability depend on actual devices running tiny-radioCD, and can easily be customized: i.e. on Pi, simple on/off push-button can be enabled with `dtoverlay=gpio-shutdown` in `usercfg.txt`.

***mpc commands*** also work under console or ssh, as last resort...



## Install procedure:

Some [ready-made images](https://github.com/macmpi/tiny-radioCD/wiki/Pre-built-images) images are available as "diskless" setup.\
They are produced with the included `unattended.sh` script to be added into [Alpine headless boostrap](https://github.com/macmpi/alpine-linux-headless-bootstrap/) environment.

Alternatively user may choose to create own install, starting from an existing [AlpineLinux setup](https://wiki.alpinelinux.org/wiki/Installation) with internet access:
```
cd /tmp
wget -O tiny-radioCD.zip https://github.com/macmpi/tiny-radioCD/archive/master.zip
unzip -oq tiny-radioCD.zip
cd tiny-radioCD
chmod +x install
./install
```

After install, bluetooth speaker pairing (and eventual remote command pairing) may be done under console or ssh (alternatively, check *[easy-setup](https://github.com/macmpi/tiny-radioCD/wiki)* section in Wiki):\
`>bluetoothctl`     After a *scan*, make sure you *pair*, *connect* and *trust* your bluetooth devices.\
Take note of your speaker MAC address `XX:XX:XX:XX:XX:XX`,and then finish speaker setup with the following command:\
`>set-speaker "XX:XX:XX:XX:XX:XX"`.

Reboot to take advantage of your new **tiny-radioCD** !



## Versions history:

```
0.6: (TBD)
- Update to Alpine 3.17
- improve Bluetooth devices detection (requires bluealsa-cli & Bluez >= 5.65)
- improve CD playback (mpd >= 0.23.9) & handling (udev rule & helper)
- add volume & mute keys support
- easy-setup available on all platforms
- replace sudo by doas, incrond by busybox inotifyd, busybox acpid by acpid, expect by sexpect
- various fixes (HDMI settings, services dependencies,streams updates,...)
- Pi: enable Bluetooth via overlays
- x86: nomodeset
- automation script for building images with Alpine headless bootstrapping utility

0.5: (May 17th 2020)
- initial release, Alpine 3.11
```



## Contributions:

Contributions are welcome in `dev` branch.



*Side note:* many other solutions exist, with more extensive feature-set & remote Web UI service (special credits to [Volumio2](https://volumio.org/)): great stuff too, different use-cases focus.

