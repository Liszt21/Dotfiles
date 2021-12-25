(ql:quickload '(clish ust inferior-shell))

(defpackage ust.script
  (:use :cl :inferior-shell))
(in-package ust.script)

(defun install ()
  (format t "Insatll conda~%")
  (run `(echo "hhhhh"))
  (run `(ust list)))

(clish:defcli main
    (install #'install))
