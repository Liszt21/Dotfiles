(use-modules (gnu) (gnu system nss) (guix utils))
(use-service-modules desktop sddm xorg ssh nix docker syncthing)
(use-package-modules ssh certs gnome)

(operating-system
 (host-name "nuc-guix")
 (timezone "Asia/Shanghai")
 (locale "en_US.UTF-8")
 (keyboard-layout (keyboard-layout "us" "altgr-intl"))

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              ;;(target "/boot/efi")
              (targets '("/boot/efi"))
              (keyboard-layout keyboard-layout)))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "MAIN"))
                       (mount-point "/")
		       (options "compress-force=zstd:15,subvol=@guix")
                       (type "btrfs"))
                      (file-system
                       (device (file-system-label "EFI"))
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems))

  ;; (swap-devices (list (swap-space (target "/swapfile"))))

 (users (cons (user-account
               (name "liszt" )
               (comment "Liszt21")
               (group "liszt")
               (supplementary-groups '("wheel" "audio" "video")))
              %base-user-accounts))

 (groups (cons* (user-group (name "liszt")) %base-groups))

 (packages
  (append
   (list nss-certs gvfs)
	 (map specification->package
		(list "bash" "vim" "tmux" "screen"
		      "coreutils" "binutils" "findutils" "diffutils" "grep"
		      "git" "ibus" "dconf" "ibus-rime"
		      "make" "gcc" "glibc"
		      "cmake"
		      "emacs-next" "emacs-rime" "emacs-all-the-icons"
		      "parinfer-rust"
		      "i3-gaps" "i3blocks" "i3status" "dmenu" "rofi" "feh"
		      "stumpwm" "xmonad" "ghc-xmonad-contrib"))
   %base-packages))

 (services (append
   (list
    (service gnome-desktop-service-type) ;;(service syncthing-service-type)
    (service nix-service-type
      (nix-configuration
        (sandbox #f)
        (extra-config '("substituters = https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org/"))))
    (service docker-service-type)
    (service openssh-service-type (openssh-configuration (x11-forwarding? #t)))
    (set-xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout))))
   (modify-services %desktop-services
     (guix-service-type config =>
       (guix-configuration
         (inherit config)
         (substitute-urls (list "https://mirror.sjtu.edu.cn/guix/" "https://substitutes.nonguix.org")))))))

 (name-service-switch %mdns-host-lookup-nss))
