(ql:quickload '(clish ust inferior-shell) :silent t)

(defpackage ust/system
  (:use :cl :inferior-shell))

(in-package ust/system)

(defun install ()
  (format t "Insatll basic applications for system~%")
  #-os-windows
  (let ((link #+X86-64 "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
              #+arm64 "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"))
    (run/interactive `(wget ,link "-O" "/tmp/miniconda-installer.sh"))
    (run/interactive "sh /tmp/miniconda-installer.sh -p ~/.miniconda -b")
    (run/interactive "~/.miniconda/bin/conda init zsh bash")))

(clish:defcli main
    (install #'install))

