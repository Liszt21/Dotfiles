(ql:quickload '(clish likit inferior-shell str) :silent t)

(defpackage ust/system
  (:use :cl :inferior-shell :likit))
(in-package ust/system)

(defparameter *config-file* #p"~/.dotfiles/config/config.lisp")

(defparameter *config* (or (and (probe-file *config-file*)
                                (with-open-file (in *config-file*)
                                  (with-standard-io-syntax (read in))))
                           '((:link) (:fork))))

(defun display-info ()
  (when (command-exists-p "neofetch")
    (run/i "neofetch")))

(defun setup ()
  (format t "Insatll basic applications for system~%")
  #+(or arch manjaro)
  (let ((server "https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch"))
    (when (not (run/ss "grep 'archlinuxcn' /etc/pacman.conf"))
      (format nil "Adding archlinuxcn: ~A~%" server)
      (run/i (format nil "sudo sed -i '$a [archlinuxcn]~%Server = ~A~%' /etc/pacman.conf" server))
      (run/i "sudo pacman -Syy")
      (run/i "sudo pacman -S archlinuxcn-keyring"))
    (run/i "sudo pacman -S yay --needed --noconfirm")))

(defun resolve-path (path)
  (parse-namestring
   (let ((s (namestring path)))
     (if (equal (subseq s 0 1) "~")
         (concatenate 'string (uiop:getenv #+os-windows "USERPROFILE" #-os-windows "HOME")
                              (subseq s 1))
         s))))

(defun same-file-p (a b)
  (and (probe-file a) (probe-file b) (equal (file-write-date a) (file-write-date b))))

(defun same-content-p (a b)
  (equal (str:from-file a) (str:from-file b)))

(defun update-links (links)
  (dolist (link links)
    (let ((source (resolve-path (getf link :source)))
          (target (resolve-path (getf link :target))))
          ;; (type (getf link :type)))
      (cond ((not source) (format t "Source file ~A does't exists, skip~%" source))
            ((or (not (probe-file target)) (same-file-p source target) (same-content-p source target))
             (run/i (format nil "ln -f ~A ~A" source target)))
            (t (format t "Target file ~A different with source file ~A ~%" target source))))))

(defun get-links (&optional (config *config*))
  (cdr (assoc :link config)))

(defun sync ()
  (format t "Updating links:~%")
  (update-links (get-links)))

(defun info ()
  (display-info))

(defun update ()
  (format nil "Updating~%")
  #+(or arch manjaro) (run/i "sudo pacman -Syu --noconfirm")
  #-os-windows (run/i "ros update likit emacy ust clish")
  (when (command-exists-p "emacy")
    (run/i "emacy update")))

(clish:defcli main
  (nil #'info)
  (info #'info)
  (update #'update)
  (setup #'setup)
  (sync #'sync))
