include .env

home:
	guix home reconfigure home.scm

system:
	sudo guix system reconfigure system.scm

build-system:
	guix system build system.scm

build-home:
	guix home build home.scm

info:
	@echo "uname" = $(shell uname -n)
	guix describe
	guix home describe

update:
	guix pull

init:
	ln -sf $(shell pwd)/config/guix/cahnnels.scm ~/.config/guix/channels.scm
