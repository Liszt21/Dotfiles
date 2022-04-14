SYSTEMS = $(wildcard ./guix/systems/*.scm)

home:
	guix home reconfigure home.scm

system:
	sudo guix system reconfigure system.scm

build-system:
	guix system build system.scm
