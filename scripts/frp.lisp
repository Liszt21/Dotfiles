(ql:quickload '(clish likit inferior-shell py-configparser) :silent t)

(defpackage ust/frp
  (:use :cl :likit)
  (:import-from :inferior-shell
                :run/i))
(in-package ust/frp)

;; https://github.com/fatedier/frp

(defun install ()
  (format t "Insatll frp~%")
  (when (not (command-exists-p "frps"))
    #-os-windows
    (let ((version "0.38.0"))
      (run/i (format nil "sudo pacman -S https://github.com/Eugeny/tabby/releases/download/v~A.tabby-~A-linux.pacman" version version)))

    #+os-windows
    (run/i "scoop install frp")))

(defun serve ()
  (format t "Run frps~%")
  (when (not (command-exists-p "frps"))
    (format t "Missing frps, installing...~%")
    (install)))

(clish:defcli main
    (install #'install)
    (serve #'serve))


