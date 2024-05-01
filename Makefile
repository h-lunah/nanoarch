SHELL := /usr/bin/zsh
.RECIPEPREFIX := $(.RECIPEPREFIX) 

all: systemd

systemd: test-sudo stoptest update-db
  @rm -rf work
  @pacman -Scc --noconfirm
  @mkarchiso -v archiso-systemd && ( rm -rf work; true ) || ( echo "Trying again..."; mkarchiso -v archiso-systemd || ( rm -rf work; false ))
  @$(MAKE) success

s6: test-sudo stoptest update-db
  @rm -rf work
  @pacman -Scc --noconfirm
  @mkarchiso -v archiso-s6 && ( rm -rf work; true ) || ( echo "Trying again..."; mkarchiso -v archiso-s6 || ( rm -rf work; false ))
  @$(MAKE) success

kernel-sudo: test-sudo stoptest
  @( cd linux && EUID=1000 makepkg -rsf && mv *.pkg.tar.zst ../repo )

kernel: recommend-sudo stoptest
  @(cd linux && makepkg -rsf && mv *.pkg.tar.zst ../repo )

update-db:
  @( cd repo; ./update.sh )

stoptest: test-qemu
  @pkill -9 "qemu" &>/dev/null && echo "QEMU terminated" || true

test: test-qemu
  @qemu-system-x86_64 -cpu qemu64 -m 1G -cdrom out/$$(eza -snew out | tail -n 1) -boot order=d -display none -vnc :0 -daemonize
  @echo "QEMU started, connect to $$(curl ipinfo.io/ip 2>/dev/null):5900"

test-qemu:
  @command -v qemu-system-x86_64 &>/dev/null || ( echo "You must install QEMU first."; false )

test-sudo:
  @test $$UID = 0 || ( echo "must be root to do this."; false )

recommend-sudo:
  @test $$UID = 0 && ( echo "rerunning as sudo..."; $(MAKE) kernel-sudo ) || true

success:
  @echo "Build successful! $$(ls -Art out | tail -n1)"
