(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "Asia/Shanghai")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (host-name "liszt-nuc")
  (users (cons* (user-account
                  (name "liszt")
                  (comment "Liszt")
                  (group "users")
                  (home-directory "/home/liszt")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
   (map specification->package
        (list "bash" "vim" "emacs" "less" "tmux" "coreutils" "findutils" "diffutils" "grep" "i3-wm" "i3status" "dmenu" "st" "nss-certs")))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service openssh-service-type)
            (service tor-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      (modify-services %desktop-services
       (guix-service-type config =>
        (guix-configuration
         (inherit config)
         (substitute-urls
          '("https://mirror.sjtu.edu.cn/guix/"
            "https://ci.guix.gnu.org")))))))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "f281b406-e123-4b29-b09e-2a7e141f9c63"
                     'btrfs))
             (type "btrfs"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "241E-39B8" 'fat32))
             (type "vfat"))
           %base-file-systems)))
