# NanoArch
Continuation of the old [MicroArch](https://github.com/xiboon/microarch) project with the aim of making [Arch Linux](https://archlinux.org) as small as possible.

# Differences
- This contains custom configurations for [systemd](https://github.com/systemd/systemd) or [s6](https://github.com/skarnet/s6) adapted to work with a regular copy of [archiso](https://archlinux.org/packages/extra/any/archiso)
- This also requires you to compile a custom kernel using the configuration provided in this repository.
- All packages added have had files stripped out their `.pkg.tar.zst` files, or recompiled with special configurations, see above.

# How to do this?
1. Set up your repository inside a profile's `pacman.conf` file, change the path to it to be `file:///home/user/nanoarch/repo`.
2. Compile a Linux kernel with the configuration provided using the command `make kernel`.
3. After setting it up run `sudo make` to build your image.<br>
<sub><sup>*Building the `s6` image requires you to set up the [Artix](https://artixlinux.org) repository with your Arch Linux system.</sub></sup>
4. Observe a boot on a VM or real hardware. If it does not work, [open an issue](https://github.com/piotr25691/nanoarch/issues/new) and we'll try to fix it.

This can save up to 80% compared to normal Arch installs but it's not recommended for beginners and feature support may be limited. Enjoy!
