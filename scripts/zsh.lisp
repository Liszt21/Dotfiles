(ql:quickload '(clish likit))

(defpackage ust.script
  (:use :cl :likit))
(in-package ust.script)

(defun install ()
  (format t "Insatll zsh~%"))

(clish:defcli main
  (install #'install))
