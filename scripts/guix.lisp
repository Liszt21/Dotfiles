(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/guix
  (:use :cl :inferior-shell :likit))
(in-package ust/guix)

(defun install ()
  #-os-windows
  (progn
    (run/i "wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh -O /tmp/guix-install.sh")
    (run/i "sudo sh /tmp/guix-install.sh")))

(clish:defcli main
    (install #'install))
