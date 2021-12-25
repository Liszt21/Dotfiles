(ql:quickload '(clish ust))

(defpackage ust.script
  (:use :cl))
(in-package ust.script)

(defun install ()
  (format t "Insatll zsh~%"))

(clish:defcli main
  (install #'install))
