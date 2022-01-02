(ql:quickload '(clish likit inferior-shell) :silent t)

(defpackage ust/starship
  (:use :cl :inferior-shell :likit :clish))
(in-package ust/starship)

;; https://github.com/starship/starship

(defun install (&key (force nil))
  (when (not (or force (command-exists-p "starship")))
    (format t "Insatll starship~%")

    #-os-windows
    (progn
      #+(or arch manjaro)
      (run/i "sudo pacman -S starship")

      #+os-windows (run/i "scoop install starship")))

  (with-profile (ctx :section "starship")
    (format t "Set init script~%")
    (setf ctx (list #+bash "eval \"$(starship init bash)\""
                    #+zsh "eval \"$(starship init zsh)\""
                    #+os-windows "Invoke-Expression (&starship init powershell)"))))

(clish:defcli main
    (install #'install))
