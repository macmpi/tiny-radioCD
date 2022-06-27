# tiny-radioCD
 A small-footprint radioCD player, for Bluetooth speakers, headphones, car-audio systems,...

This personal project is geared towards simple & essential use-cases for casual listeners using Bluetooth speakers, and missing their good-old Audio CDs playback...


## <u>Main Features:</u>

- Audio-CD & web radio player

- Sound output to any Bluetooth audio equipment, and available default audio port (can be HiFi DAC)

- Simple remote control via Bluetooth keys and/or network mpc client

- Focus on ease of use & efficiency under low memory & hardware requirements (based on [AlpineLinux](https://www.alpinelinux.org/))

- Headless operation, one-touch update

\
**tiny-radioCD** just relies on [MPD](https://www.musicpd.org/), ALSA and [bluez-alsa](https://github.com/Arkq/bluez-alsa/): it does not need to provide a graphical remote UI.\
Typically runs in 50MB of RAM on a low-cost PiZero device (135 MB rootf suitable for RAM-only operation).\
Check-out our minimalistic USB-powered [PiZeroWed-Mac mini](https://github.com/macmpi/tiny-radioCD/wiki/PiZeroWed-Mac-mini)!

Though mostly tested on Pi, it would run on any AlpineLinux supported platform (diskless/data/sys modes).\
Some ready-to-use images are available (Raspberry Pi armhf ram-only SD archive for instance).\
Customized installs can be included as simple addon-scripts (refer to available Pi example).



## Seamless user operation:

Player control (play/pause/etc...) is naturally operated with bluetooth speaker/headphone ***built-in keys***.
Volume adjustment is set by speaker amplification stage.

***Multimedia bluetooth remotes*** are a perfect match too, allowing extended use-cases.\
Typically, the low-cost first-generation ***FireTV remote*** (& clone) works great (more info in [Wiki](https://github.com/macmpi/tiny-radioCD/wiki)).\
***USB Keyboards*** with multimedia keys are supported too.

With network availability, any ***mpc client application*** can easily connect to **tiny-radioCD** player with Avahi discovery, and provide convenient user interface.\
[***MaximumMPD***](https://itunes.apple.com/gb/app/maximummpd/id1437096437?mt=8) on iOS is a good example of such clients, but there are many other available on any platforms.

***Hardware buttons*** (power on/off, eject) availability depend on actual devices running tiny-radioCD, and can easily be customized: i.e. on Pi, simple on/off push-button can be enabled with `dtoverlay=gpio-shutdown` in `usercfg.txt`.

***mpc commands*** also work under console or ssh, as last resort...



## Install procedure:

If you don't use [ready-made images](https://github.com/macmpi/tiny-radioCD/wiki/Pre-built-images), just do the following on your [AlpineLinux device](https://wiki.alpinelinux.org/wiki/Installation) with internet access:
```
cd /tmp
wget -O tiny-radioCD.zip https://github.com/macmpi/tiny-radioCD/archive/master.zip
unzip -oq tiny-radioCD.zip
cd tiny-radioCD
chmod +x setup-tiny-radioCD
sudo ./setup-tiny-radioCD
```

After install, bluetooth speaker pairing (and eventual remote command pairing) may be done under console or ssh (alternatively, check *[easy-setup](https://github.com/macmpi/tiny-radioCD/wiki)* section in Wiki):\
`>bluetoothctl`     After a <u>scan</u>, make sure you <u>pair</u>, <u>connect</u> and <u>trust</u> your bluetooth devices.\
Take note of your speaker MAC address `XX:XX:XX:XX:XX:XX`\
Then finish speaker setup with the below command:\
`>set-speaker "XX:XX:XX:XX:XX:XX"`\

Reboot to take advantage of your new **tiny-radioCD**!



## Versions history:

```
0.6: (TBD)
- Update to Alpine 3.16
- replace sudo by doas
- use busybox inotifyd instead of incrond
- various fixes (HDMI, services dependencies,TSF stream,...)
- Pi: enable Bluetooth via overlays

0.5: (May 17th 2020)
- initial release, Alpine 3.11
```



## Contributions:

Contributions are welcome in `dev` branch.



<u>Side note:</u> several very generic & complete packages exist, with extensive feature-set & remote Web UI service (special credits to [Volumio2](https://volumio.org/)): great stuff too, different use-cases focus.

