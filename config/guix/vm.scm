(define-module (wsl)
  #:use-module (gnu)
  #:use-module (gnu services ssh)
  #:use-module (gnu services networking)
  #:use-module (gnu packages version-control)
  #:use-module (guix channels)
  #:use-module (guix packages)
  #:use-module (guix profiles)
  #:use-module (ice-9 pretty-print)
  #:use-module (srfi srfi-1))

(define-public os
  (operating-system
   (host-name "guix")
   (keyboard-layout (keyboard-layout "us" "altgr-intl"))

   ;; User account
   (users (cons (user-account
                 (name "liszt")
                 (group "users")
                 (home-directory "/home/liszt")
                 (supplementary-groups '("wheel")))
                %base-user-accounts))

   (kernel hello)
   (initrd (lambda* (. rest) (plain-file "dummyinitrd" "dummyinitrd")))
   (initrd-modules '())
   (firmware '())

   (bootloader
    (bootloader-configuration
     (bootloader
      (bootloader
       (name 'dummybootloader)
       (package hello)
       (configuration-file "/dev/null")
       (configuration-file-generator (lambda* (. rest) (computed-file "dummybootloader" #~(mkdir #$output))))
       (installer #~(const #t))))))

   (file-systems (list (file-system
                        (device "/dev/sdb")
                        (mount-point "/")
                        (type "ext4")
                        (mount? #t))))

   (services (list (service guix-service-type
                            (guix-configuration
                             (substitute-urls (list
                              "https://mirror.sjtu.edu.cn/guix/"
                              "https://ci.guix.gnu.org"
                              ))))
                   (service special-files-service-type
                            `(("/usr/bin/env" ,(file-append coreutils "/bin/env"))))))))
os