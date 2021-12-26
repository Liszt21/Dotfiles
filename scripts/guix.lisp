(ql:quickload '(clish ust inferior-shell) :silent t)

(defpackage ust/guix
  (:use :cl :inferior-shell))

(in-package ust/guix)

(defun install ()
  (format t "Install nutstore")
  #-os-windows
  (progn
    (inferior-shell:run/interactive "wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh -O /tmp/guix-install.sh")
    (inferior-shell:run/interactive "chmod +x /tmp/guix-install.sh")
    (inferior-shell:run/interactive "sudo sh /tmp/guix-install.sh")))

(clish:defcli main
    (install #'install))
