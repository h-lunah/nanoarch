all: test-sudo
	install -Dm644 ./usr/share/pacman/keyrings/* /usr/share/pacman/keyrings
	install -Dm644 ./etc/pacman.d/* /etc/pacman.d
	rm -rf /etc/pacman.d/gnupg
	pacman-key --init
	pacman-key --populate
test-sudo:
	@test $$UID = 0 || ( echo "error: you can only install artix mirrors as root."; false )
