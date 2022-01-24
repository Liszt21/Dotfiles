(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/proxy
  (:use :cl :inferior-shell :likit))
(in-package ust/proxy)

(defun load-config (&optional (path #p"~/.config/proxy/config"))
  (if (probe-file path)
    (with-open-file (in path)
      (with-standard-io-syntax
        (read in)))))

(defparameter *config* (load-config))

(defparameter *provider* '())

(defun install ()
  (when (not (command-exists-p "proxychains"))
    (run/i #+(or arch manjaro) "sudo pacman -S proxychains --needed --noconfirm"))

  #+os-windows (run/i "sudo pacman -S clash --needed --noconfirm"))

(defun use (type) ())

(defun subscribe (url))

(defun update ())

(defun start ())

(defun stop ())

(defun toggle (&optional (status t)))

(clish:defcli main (:docs "proxy manager")
  (use #'use)
  (stop #'stop)
  (start #'start)
  (toggle #'toggle)
  (install #'install)
  (subscribe #'subscribe))

