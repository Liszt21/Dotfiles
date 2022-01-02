(ql:quickload '(clish likit))

(defpackage ust/zsh
  (:use :cl :likit))
(in-package ust/zsh)

(defun install ()
  (format t "Insatll zsh~%"))

(clish:defcli main
  (install #'install))
