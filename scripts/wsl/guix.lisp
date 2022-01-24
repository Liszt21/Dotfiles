(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/guix
  (:use :cl :inferior-shell :likit))
(in-package ust/guix)

(defun path (base &rest args)
  (pathname (str:join "/" (cons (if (pathnamep base) (namestring base) base) args))))

#+os-windows
(defvar home (path "/mnt" (subseq (string-downcase (uiop:getenv "HOMEDRIVE")) 0 1)
                   "Users" (uiop:getenv "USERNAME")
                   ".dotfiles" ""))

(defun successp (cmd) (zerop (third (multiple-value-list (run/nil cmd :on-error nil)))))

(defun install ()
  #+os-windows ;; https://github.com/SystemCrafters/wiki-site/blob/main/content/guix/wsl.org
  (let* ((wsl-home (path (uiop:getenv "HOMEDRIVE") "WSL" "Guix" ""))
         (rootfs-url "https://github.com/0xbadfca11/miniwsl/releases/download/release3041562/rootfs.tgz")
         (rootfs-path (path wsl-home "rootfs.tgz")))
    (uiop:ensure-all-directories-exist (list wsl-home))
    (when (and (successp "wsl -d Guix -- echo")
               (y-or-n-p "Guix exists, remove?"))
      (run/i "wsl --unregister Guix"))
    (when (not (probe-file rootfs-path))
      (run/i (format nil "wget ~A ~A" rootfs-url rootfs-path)))
    (run/i (format nil "wsl -d Guix -u root -- sh ~A/scripts/wsl/wsl-install ~A/config/guix/wsl.scm" home home))))

#+os-windows
(defun init ()
  (let ((init-file (path home "scripts" "wsl" "wsl-init")))
    (run/i (format nil "wsl -d Guix -u root -- sh ~A" init-file))))

(clish:defcli main (:docs "guix for wsl")
  (install #'install)
  #+os-windows
  (init #'init))

