;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu packages admin)
  (gnu packages syncthing)
  (gnu packages package-management)
  (gnu services)
  (gnu services nix)
  (guix gexp)
  (gnu home services)
  (gnu home services shells)
  (gnu home services shepherd))

(define @home (load "guix/home.scm"))
(define @lisux-home "${HOME}/Lisux")
(define @dotfiles "${HOME}/Dotfiles")

(define machine-name (vector-ref (uname) 1))

(define syncthing-service
  (shepherd-service
   (provision '(syncthing))
   (documentation "Run syncthing")
   (respawn? #t)
   (start #~(make-forkexec-constructor
             (list #$(file-append syncthing "/bin/syncthing")
                   "--no-browser" "--logflags=3" "--logfile=~/.local/var/log/syncthing.log")))
   (stop #~(make-kill-destructor))))

(define nix-service
  (shepherd-service
   (provision '(nix-daemon))
   (documentation "Run nix daemon")
   (respawn? #t)
   (start #~(make-forkexec-constructor
             (list #$(file-append nix "/bin/nix-daemon")
                   "--substituters=\"https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org/\"")))
   (stop #~(make-kill-destructor))))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list ;; -- personal
               ;; "roswell"

               ;; -- basic
               "git"
               "unzip"
               "zile"
               "recutils"
               "syncthing"
               "fish"
               "nix"
               ;; "bash-completion"
               ;;
               "glibc-locales"

               ;; -- fonts
               "font-sarasa-gothic"
               "font-adobe-source-code-pro"
               "font-fira-code"
               "font-gnu-unifont"
               "emacs-all-the-icons"

               ;; -- applications
               ;; "tigervnc-server"
               ;; "nyxt"
               ;; "qemu"

               ;; -- develop
               ;; "make" "gcc" "gnupg"
               ;; "cmake"
               ;; "conda" "python"
               ;; "node"
               ;; "julia"
               ;; "clojure"
               ;; "nim"
               ;; "go"
               ;; "php"
               ;; "perl"
               ;; "ghc"

               ;; -- virtual machine
               ;; "virt-manager"
               ;; "virt-viewer"

               ;; -- emacs
               ;; "parinfer-rust"

               ;; -- tools
               ;; "vlc"
               ;; "mpv"
               ;; "gimp"
               ;; "blender"
	       )))
  (services
    (list
     ;; (service
     ;;  home-shepherd-service-type
     ;;  (home-shepherd-configuration
     ;;   (shepherd shepherd)
     ;;   (services
     ;;    (list
     ;;     syncthing-service
     ;;     ;; nix-service
     ;;     ))))
     (service
      home-fish-service-type
      (home-fish-configuration
       (environment-variables
        `(("TEST" . "test")))
       (config (list (local-file "config/fish/config.fish")))))
     (service
       home-bash-service-type
       (home-bash-configuration
         (environment-variables `(("GTK_IM_MODULE" . "fcitx")))
         (aliases '())
         (bashrc (list (local-file "bashrc" "bashrc")))
         (bash-profile (list (local-file "bash_profile" "bash_profile"))))))))
