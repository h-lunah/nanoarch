SHELL := /usr/bin/zsh
.RECIPEPREFIX := $(.RECIPEPREFIX) 

all: test-sudo stoptest
  @rm -rf work
  @printf "What image do you want?\nType in 'systemd' for a known working image, or type in 's6' for an unstable version of NanoArch.\n> "
  @read type; mkarchiso -v archiso-$$type && ( rm -rf work; true ) || ( rm -rf work; false )
  @echo "Done, run 'make test' to attempt boot. You can also try on real hardware."

kernel: test-sudo stoptest
  @( cd linux && EUID=1000 makepkg -rsf && mv *.tar.zst ../repo )
  @( cd repo && ./update.sh )

stoptest:
  @killall -9 "qemu-system-x86_64" &>/dev/null && echo "QEMU terminated" || true

test:
  @qemu-system-x86_64 -cpu qemu64 -m 1G -cdrom out/$$(eza -snew out | tail -n 1) -boot order=d -display none -vnc :0 -daemonize
  @echo "QEMU started, connect to $$(curl ipinfo.io/ip 2>/dev/null):5900"

test-sudo:
  @test $$UID = 0 || ( echo "must be root to do this."; false )
