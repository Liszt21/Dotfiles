(use-modules
  (gnu)
  (guix profiles)
  (guix packages)
  (srfi srfi-1))

(use-service-modules networking ssh)

(define-public os
(operating-system
  (host-name "wsl-guix")
  (timezone "Asia/Shanghai")
  (locale "en_US.utf8")

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

  (users (cons (user-account
                (name "liszt")
                (group "users")
                (supplementary-groups '("wheel")))
               %base-user-accounts))

(packages
    (append
     (cons*
      (map  ( compose list specification->package+output)
	    `(  "openssh" "git" "nss-certs"  ; packages here
	       )))  %base-packages ))

  (services (list (service guix-service-type)))))


os
