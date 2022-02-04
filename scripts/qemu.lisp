(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/qemu
  (:use :cl :likit)
  (:import-from :inferior-shell
                :run/i))
(in-package ust/qemu)

(defparameter *home* (pathname (format nil "~A/Qemu/" (or (uiop:getenv "HOME") "~"))))

(defun install ()
  (format t "Insatll qemu~%")
  (when (not (command-exists-p "qemu-img"))
    #+os-windows (run/i (format nil "scoop install qemu"))
    #+(or arch manjaro) (run/i "sudo pacman -S qemu")))

(defun machine-info (name &key (home *home*))
  (let ((folder (probe-file (merge-pathnames name home))))
    (pairlis (list :shots) (list (mapcar #'pathname-name (directory (parse-namestring (format nil "~Asystem*.qcow2" folder))))))))

(defun create-machine (name image &key (arch "x86_64") (home *home*))
  (let ((file (pathname (format nil "~A/~A/system.qcow2" home name))))
    (when (not (probe-file file))
      (uiop:ensure-all-directories-exist (list file))
      (run/i (format nil "qemu-img create -f qcow2 ~A 157G" file))
      (run/i (format nil "qemu-system-~A -m 2048 -smp 1 -nic user,model=virtio-net-pci -boot menu=on,order=d -drive file=~A -drive media=cdrom,file=~A" arch file image)))))

(defun delete-machine (name &key (home *home*))
  (let ((folder (probe-file (merge-pathnames name home))))
    (if folder
        (run/i (format nil "rm ~A ~A" #+os-windows "-R" #-os-windows "-r" folder))
        (format t "System ~A not exists" name))))

(defun run-machine (name &key (home *home*) (arch "x86_64") (memory "2048") shot)
  (let ((folder (probe-file (merge-pathnames name home))))
    (when folder
      (run/i (format nil "qemu-system-~A -m ~A -smp 1 -nic user,model=virtio-net-pci -drive file=~Asystem~A.qcow2"
                     arch memory folder (or (and shot (format nil "-~A" shot)) ""))))))

(defun list-machines (&optional (home *home*))
  (loop for folder in (directory
                       (make-pathname :directory (pathname-directory (uiop:ensure-directory-pathname home))
                                      :name :wild
                                      :type nil))
        for name = (car (last (pathname-directory folder)))
        do (progn (print name))))

(defun timestamp ()
  (multiple-value-bind
    (s m h d mm y) (get-decoded-time)
    (format nil "~D~2,'0D~2,'0D~2,'0D~2,'0D~2,'0D" y mm d h m s)))

(defun take-snapshot (name &optional shot (home *home*))
  (let ((folder (probe-file (merge-pathnames name home))))
    (when folder
      (run/i (format nil "cp ~A/system.qcow2 ~Asystem~A.qcow2" folder folder (format nil "-~A" (or shot (timestamp))))))))

(clish:defcli main
    (run #'run-machine)
    (info (lambda (name) (print (machine-info name)) (format t "~%")))
    (shot #'take-snapshot)
    (install #'install)
    (create #'create-machine)
    (delete #'delete-machine)
    (list #'list-machines))
