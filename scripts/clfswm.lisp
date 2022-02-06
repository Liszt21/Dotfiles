(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/clfswm
  (:use :cl :inferior-shell :likit))
(in-package ust/clfswm)

(defun install ()
    (format t "Insatll clfswm~%")
    #-os-windows
    (progn
        (run/i "ros install clfswm")
        (run/i "ros build ~/.dotfiles/config/clfswm/clfswm.ros")
        (run/i "sudo mv ~/.dotfiles/config/clfswm/clfswm /usr/bin/clfswm")
        (run/i "ln -s ~/.dotfiles/config/clfswm ~/.config/clfswm")
        (run/i "sudo cp ~/.dotfiles/config/clfswm/clfswm.desktop /usr/share/xsessions/clfswm.desktop")))

(clish:defcli main
    (install #'install))


