(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/conda
  (:use :cl :inferior-shell :likit))
(in-package ust/conda)

(defun install ()
  (when (not (command-exists-p "conda"))
    (format t "Insatll conda~%")
    #-os-windows
    (let ((link #+x86-64 "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
                #+arm64 "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"))
      (format t "Download miniconda: ~A~%" link)
      (run/i `(wget ,link "-O" "/tmp/miniconda-installer.sh"))
      (run/i "sh /tmp/miniconda-installer.sh -p ~/.miniconda -b")
      (run/i "~/.miniconda/bin/conda init zsh bash"))

    #+os-windows
    (run/i "scoop install miniconda")))

(clish:defcli main
    (install #'install))

