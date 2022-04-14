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
  (gnu services)
  (guix gexp)
  (gnu home services)
  (gnu home services shells)
  (gnu home services shepherd))

(define @lisux-home "${HOME}/Lisux")
(define @dotfiles "${HOME}/Dotfiles")

(define syncthing-service
  (shepherd-service
   (provision '(syncthing))
   (documentation "Run syncthing")
   (respawn? #t)
   (start #~(make-forkexec-constructor
             (list #$(file-append syncthing "/bin/syncthing")
                   "--no-browser" "-logflags=3" "-logfile=~/.local/var/log/syncthing.log")))
   (stop #~(make-kill-destructor))))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list "git"
               "recutils"
               ;; "unrar"
               "unzip"
               "zile"
               "syncthing"
               "bash-completion"

               ;; -- fonts
               "font-sarasa-gothic" "font-adobe-source-code-pro" "font-fira-code" "emacs-all-the-icons"

               ;; -- applications
               "tigervnc-server"
               "nyxt"
               "qemu"
               "rpm"
               ;; -- develop
               "make" "gcc" "gnupg"
               "cmake"
               "conda"
               "python" "python-pip"
               "node"
               "julia"
               "clojure"
               "nim"
               "go"
               "php"
               "perl"
               "ghc"

               ;; -- virtual machine
               "virt-manager"
               "virt-viewer"

               ;; -- emacs
               ;; "parinfer-rust"

               ;; -- tools
               "vlc"
               "mpv"
               "gimp"
               "blender")))
  (services
    (list
     (simple-service
      'guix-channels-config home-xdg-configuration-files-service-type
      `(("guix/channels.scm" ,(local-file "config/guix/channels.scm"))))
     (service
      home-shepherd-service-type
      (home-shepherd-configuration
       (shepherd shepherd)
       (services
        (list syncthing-service))))
     (service
       home-bash-service-type
       (home-bash-configuration
         (environment-variables
          `(("GUIX_BUILD_OPTIONS" . "\"--substitute-urls=https://mirror.sjtu.edu.cn/guix --load=path=~/Lisux\"")
            ("GTK_IM_MODULE" . "fcitx")))
         (aliases
           '(("grep" . "grep --color=auto")
             ("ll" . "ls -l")
             ("ls" . "ls -p --color=auto")))
         (bashrc (list (local-file "bashrc" "bashrc")))
         (bash-profile (list (local-file "bash_profile" "bash_profile"))))))))