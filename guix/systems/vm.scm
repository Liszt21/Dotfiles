;; see https://git.sjtu.edu.cn/sjtug/guix/-/blob/master/gnu/system/examples/vm-image.tmpl
(use-modules (gnu) (guix) (srfi srfi-1))
(use-service-modules desktop mcron networking spice ssh xorg sddm)
(use-package-modules bootloaders certs fonts nvi
                     package-management wget xorg)

(define vm-image-motd (plain-file "motd" "
\x1b[1;37mThis is the GNU system.  Welcome!\x1b[0m

This instance of Guix is a template for virtualized environments.
You can reconfigure the whole system by adjusting /etc/config.scm
and running:

  guix system reconfigure /etc/config.scm

Run '\x1b[1;37minfo guix\x1b[0m' to browse documentation.

\x1b[1;33mConsider setting a password for the 'root' and 'guest' \
accounts.\x1b[0m
"))

(define auto-update-resolution-crutch
  #~(job '(next-second)
         (lambda ()
           (setenv "DISPLAY" ":0.0")
           (setenv "XAUTHORITY" "/home/liszt/.Xauthority")
           (execl (string-append #$xrandr "/bin/xrandr") "xrandr" "-s" "0"))
         #:user "liszt"))

(operating-system
  (host-name "vm")
  (timezone "Asia/Shanghai")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  ;; Label for the GRUB boot menu.
  (label (string-append "GNU Guix " (package-version guix)))

  (firmware '())

  ;; Below we assume /dev/vda is the VM's hard disk.
  ;; Adjust as needed.
  (bootloader (bootloader-configuration
               (bootloader grub-bootloader)
               (targets '("/dev/vda"))
               (terminal-outputs '(console))))
  (file-systems (cons (file-system
                        (mount-point "/")
                        (device "/dev/vda1")
                        (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "liszt")
                (comment "GNU Guix Live")
                (password "")                     ;no password
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  ;; Our /etc/sudoers file.  Since 'guest' initially has an empty password,
  ;; allow for password-less sudo.
  (sudoers-file (plain-file "sudoers" "\
root ALL=(ALL) ALL
%wheel ALL=NOPASSWD: ALL\n"))

  (packages (append (list font-bitstream-vera nss-certs nvi wget)
                    %base-packages))

  (services
   (append (list (service xfce-desktop-service-type)

                 ;; Choose SLiM, which is lighter than the default GDM.
                 (service slim-service-type
                          (slim-configuration
                           (auto-login? #t)
                           (default-user "liszt")
                           (xorg-configuration
                            (xorg-configuration
                             ;; The QXL virtual GPU driver is added to provide
                             ;; a better SPICE experience.
                             (modules (cons xf86-video-qxl
                                            %default-xorg-modules))
                             (keyboard-layout keyboard-layout)))))

                 ;; Uncomment the line below to add an SSH server.
                 ;;(service openssh-service-type)

                 ;; Add support for the SPICE protocol, which enables dynamic
                 ;; resizing of the guest screen resolution, clipboard
                 ;; integration with the host, etc.
                 (service spice-vdagent-service-type)

                 (simple-service 'cron-jobs mcron-service-type
                                 (list auto-update-resolution-crutch))

                 ;; Use the DHCP client service rather than NetworkManager.
                 (service dhcp-client-service-type))

           ;; Remove some services that don't make sense in a VM.
           (remove (lambda (service)
                     (let ((type (service-kind service)))
                       (or (memq type
                                 (list gdm-service-type
                                       sddm-service-type
                                       wpa-supplicant-service-type
                                       cups-pk-helper-service-type
                                       network-manager-service-type
                                       modem-manager-service-type))
                           (eq? 'network-manager-applet
                                (service-type-name type)))))
                   (modify-services %desktop-services
                     (login-service-type config =>
                                         (login-configuration
                                          (inherit config)
                                          (motd vm-image-motd)))))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
