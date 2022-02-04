(ql:quickload '(clish ust inferior-shell) :silent t)

(defpackage ust/nutstore
  (:use :cl :inferior-shell))
(in-package ust/nutstore)

(defun install (&key (force nil))
  (format t "Install nutstore~%")
  #-os-windows
  (when (or force (not (probe-file #p"~/.nutstore/dist/bin/nutstore-pydaemon.py")))
    #+(or arch manjaro) (run/i "sudo pacman -S python-gobject libnotify webkit2gtk libappindicator-gtk3 gvfs")
    #+(or debian ubuntu) (run/i "sudo apt-get install  gvfs-bin python3-gi gir1.2-appindicator3-0.1")
    #+(or centos fedora) (run/i "sudo yum install gvfs libappindicator-gtk3 python3-gobject")

    (run/i "wget https://www.jianguoyun.com/static/exe/installer/nutstore_linux_dist_x64.tar.gz -O /tmp/nutstore_bin.tar.gz")
    (run/i "mkdir -p ~/.nutstore/dist && tar zxf /tmp/nutstore_bin.tar.gz -C ~/.nutstore/dist")
    (run/i "~/.nutstore/dist/bin/install_core.sh")))

(defun uninstall()
  (format t "Remove nutstore~%")
  (run/i "rm -rf ~/.nutstore"))

(clish:defcli main
  (install #'install)
  (remove #'uninstall))

