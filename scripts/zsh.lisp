(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/zsh
  (:use :cl :likit :inferior-shell))
(in-package ust/zsh)

(defun install ()
  (format t "Insatll zsh~%"))

(clish:defcli main
  (install #'install))
