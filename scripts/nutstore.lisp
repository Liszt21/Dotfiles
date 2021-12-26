(ql:quickload '(clish ust inferior-shell) :silent t)

(defpackage ust/nutstore
  (:ust :cl))

(in-package ust/nutstore)

(defun install ()
  (format t "Install nutstore")
  #-os-windows
  (progn
    (inferior-shell:run "wget https://www.jianguoyun.com/static/exe/installer/nutstore_linux_dist_x64.tar.gz -O /tmp/nutstore_bin.tar.gz")
    (inferior-shell:run "mkdir -p ~/.nutstore/dist && tar zxf /tmp/nutstore_bin.tar.gz -C ~/.nutstore/dist")
    (inferior-shell:run "~/.nutstore/dist/bin/install_core.sh")))

(clish:defcli main
  (install #'install))

