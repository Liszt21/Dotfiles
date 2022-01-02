(ql:quickload '(clish likit inferior-shell str) :silent t)

(defpackage ust/system
  (:use :cl :inferior-shell :likit))
(in-package ust/system)

(defun display-info ()
  (when (command-exists-p "neofetch")
    (run/i "neofetch")))

(defun setup ()
  (format t "Insatll basic applications for system~%")

  #+(or arch manjaro)
  (let ((server "https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch"))
    (when (not (run/ss "grep 'archlinuxcn' /etc/pacman.conf"))
      (format nil "Adding archlinuxcn: ~A~%" server)
      (run/i (format nil "sudo sed -i '$a [archlinuxcn]~%Server = ~A~%' /etc/pacman.conf" server))
      (run/i "sudo pacman -Syy")
      (run/i "sudo pacman -S archlinuxcn-keyring"))
    (run/i "sudo pacman -S yay --needed --noconfirm"))

  (run/i "sudo pacman -S firefox syncthing clash julia --needed ")
  (run/i "yay -S syncthingtray visual-studio-code-bin --needed --noconfirm")

  ;; set fonts
  (run/i "ttf-fira-code adobe-source-code-pro-fonts --needed")

  ;; applications
  (run/i "yay wechat")
  (run/i "yay -S baidunetdisk-bin --needed"))

(clish:defcli main
    (setup #'setup))

(display-info)
