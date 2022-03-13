(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/stumpwm
  (:use :cl :inferior-shell :likit))
(in-package ust/stumpwm)

(defun install ()
    (format t "Insatll stumpwm~%")
    #-os-windows
    (progn
        (run/i "ros install stumpwm")
        (run/i "ros build ~/.dotfiles/config/stumpwm/stumpwm.ros")
        (run/i "sudo mv ~/.dotfiles/config/stumpwm/stumpwm /usr/bin/stumpwm")
        (run/i "ln -s ~/.dotfiles/config/stumpwm ~/.config/stumpwm")
        (run/i "sudo cp ~/.dotfiles/config/stumpwm/stumpwm.desktop /usr/share/xsessions/stumpwm.desktop")))

(clish:defcli main
    (install #'install))


