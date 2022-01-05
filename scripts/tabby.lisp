(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/tabby
  (:use :cl :likit :inferior-shell))
(in-package ust/tabby)

;; https://github.com/eugeny/tabby

(defun install ()
  (format t "Insatll tabby~%")
  (when (not (command-exists-p "tabby"))
    #-os-windows
    (let ((version "1.0.169"))
      #+(or arch manjaro)
      (run/i (format nil "sudo pacman -S https://github.com/Eugeny/tabby/releases/download/v~A.tabby-~A-linux.pacman" version version)))

    #+os-windows
    (run/i "scoop install tabby")))

(clish:defcli main
    (install #'install))
