(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/nvm
  (:use :cl :inferior-shell :likit))
(in-package ust/nvm)

(defun install ()
  (when (not (command-exists-p "nvm"))
    #-os-windows
    (progn
      (run/i "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash"))

    #+os-windows
    (run/i "scoop install nvm")))

(clish:defcli main
    (install #'install))

