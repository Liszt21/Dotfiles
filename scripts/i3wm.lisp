(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/i3wm
  (:use :cl :inferior-shell :likit))
(in-package ust/i3wm)

(defun install ()
  #+os-unix
  (when (not (command-exists-p "i3"))
    #+(or arch manjaro)
    (run/i "sudo pacman -S i3-gaps i3blocks i3lock i3status rofi picom dmenu feh polybar --noconfirm --needed")))


(defun setup ()
  #+os-unix
  (dolist (link '("config/i3" "config/polybar" "config/picom" "config/feh"))
    (when (probe-file (format nil "~~/.dotfiles/~A" link))
      (format t "Link ~~/.dotfiles/~A to ~~/.~A~%" link link)
      (run/i (format nil "ln -s -f -b ~~/.dotfiles/~A ~~/.~A" link link)))))

(clish:defcli main
    (install #'install)
    (setup #'setup))

