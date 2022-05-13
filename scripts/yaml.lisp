(ql:quickload '(clish likit cl-yaml str) :silent t)

(defpackage ust/yaml
  (:use :cl :likit :cl-yaml :str))
(in-package ust/yaml)

(defparameter *table* (make-hash-table :test #'equal))

(defun pathname-parents (path)
  (let ((directory '())
        (host (pathname-host path))
        (device (pathname-device path)))
    (reverse (loop for name in (pathname-directory path)
                   do (push name directory)
                   collect (make-pathname :host host :device device :directory (reverse directory))))))

(defun detect-config-file (&optional (name "config.yaml"))
  (eval `(or ,@(mapcar (lambda (p) (probe-file p))
                       (append (mapcar (lambda (p) (merge-pathnames name p)) (pathname-parents (probe-file ".")))
                               (list #p"~/Sync/config.yaml" #p"~/.config/config.yaml" #p"~/Dotfiles/config.yaml" #p"~/.dotfiles/config.yaml"))))))

(defun detect-config-files (&optional (name "config.yaml"))
  (remove-duplicates
   (remove nil
    (mapcar (lambda (p) (probe-file p))
          (append (mapcar (lambda (p) (merge-pathnames name p)) (pathname-parents (probe-file ".")))
                  (list #p"~/Sync/config.yaml" #p"~/.config/config.yaml" #p"~/Dotfiles/config.yaml" #p"~/.dotfiles/config.yaml"))))))

(defun load-config (&optional (name "config.yaml"))
  (dolist (file (detect-config-files name))
    (let ((table (parse (from-file file))))
      (when table
        (maphash (lambda (k v)
                   (setf (gethash k *table*) v))
                 table)))))

(load-config)

(defun get-config (&rest keys)
  (if keys
      (loop for key in keys
            collect (gethash key *table*))
      *table*))

(clish:defcli main
  ;; (:before (lambda (keys) (pprint keys)))
  ;; (:after (lambda (args result) (pprint result)))
  (get #'get-config))
