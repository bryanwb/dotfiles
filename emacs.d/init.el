;; This is an emacs file I created to customize emacs
;; The settings should take effect on emacs start-up
;; compilation on fedora
;; curl from http://gnu.mirror.globo.tech/emacs/ and untar
;;  $ ./autogen.sh
;;  $ sudo dnf install -y gtk3-devel libXpm-devel libtiff-devel gnutls-devel \
;;     libjpeg-turbo-devel giflib-devel ncurses-devel ImageMagick-devel \
;;     webkit2gtk3-devel
;;  $ ./configure --with-xwidgets --with-x --with-x-toolkit=gtk3 --with-modules
;   $ make && make install


;; Global keymappings for sanity
;; M-o toggle vterm
;; M-j toggle vterm copy mode
;; C-` 'magit-status
;; C-f 'projectile-command-map, i.e. projectile hot-key
;; C-f l 'projectile-find-file-other-window
;; M-m 'whitespace-cleanup
;; M-z 'bwb-zap-whitespace-to-char  delete all whitespace up to first non-ws char or end-of-line
;; M-y counsel-yank-pop shows kill ring
;; C-j ivy-switch-buffer
;; C-c j ivy-immediate-done
;; C-x C-f 'counsel-find-file
;; M-x counsel-M-x
;; C-s 'swiper
;; M-t 'revert-buffer
;; C-c c 'org-capture
;; M-j term-toggle b/w line and char mode
;; C-c C-r 'ivy-resume
;; C-c i m  'counsel-imenu
;; C-x t 'helm-mt
;; C-c j ivy-immediate-done stop ivy autocompletion
;; M-l 'counsel-bookmark

;; aliases
;; activate pyvenv-activate
;; cg 'counsel-git
;; cgg 'counsel-git-grep


;; for some reason setting this to nil, stops emacs from hanging on kill-line
;; https://github.com/syl20bnr/spacemacs/issues/6752
;; added 16 March 2020
(setq x-select-enable-clipboard nil)

;; passwords go in this private file
;; currently hold gitlab secrets
(load "~/dotfiles/secrets/secrets.el")

(add-to-list 'load-path "~/.emacs.d/lisp")

;; this ensures that I am not asked to confirm that the theme can be loaded
(setq custom-safe-themes t)

;; packaging setup
(require 'package)
(setq package-archives '(
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

(setq *is-a-mac* (eq system-type 'darwin))
(setq *win64* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )

(require 'use-package)

;; shell config
;; from https://github.com/akermu/emacs-libvterm
;; and https://github.com/jixiuf/vterm-toggle
(use-package vterm-toggle
  :ensure t
  :config
  (progn
    (add-to-list 'load-path "/home/hitman/local/emacs-libvterm")
    (require 'vterm)
    (setq vterm-shell "/usr/bin/nu")
    (define-key global-map (kbd "M-o") 'vterm-toggle-cd)
    (define-key vterm-mode-map (kbd "M-j") 'vterm-copy-mode)
    (define-key vterm-mode-map (kbd "C-j") 'ivy-switch-buffer)
    (define-key vterm-mode-map (kbd "C-l") 'other-window)
    (define-key vterm-copy-mode-map (kbd "M-j") 'vterm-copy-mode)))

(use-package beacon
  :ensure t
  :config
  (progn
    (beacon-mode 1)))

(use-package solidity-mode
  :ensure t
  :config
  (progn
    (setq solidity-flycheck-solium-checker-active t)
    (add-to-list 'auto-mode-alist '("\\.sol\\'" . solidity-mode))
    (add-hook 'solidity-mode-hook
              (lambda ()
                (define-key solidity-mode-map (kbd "C-j") 'ivy-switch-buffer)))))
 
;; java setup
;; taken from http://www.skybert.net/emacs/enterprise-java-development-in-emacs/
;; extra setup, download eclipse jdt and unpack manually to ~/.lsp-java-jdk
;; (use-package treemacs
;;   :ensure t)

;; (use-package lsp-java
;;   :ensure t
;;   :after lsp
;;   :config
;;   (progn
;;     (setq lsp-java-java-path "/usr/lib/jvm/java-9-openjdk-9.0.4.11-6.fc28.x86_64/bin/java")
;;     (setq lsp-java-server-install-dir "/home/hitman/.lsp-java-jdt/")
;;     (add-hook 'java-mode-hook 'lsp)
;;     ))

(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java :after (lsp-java))
(use-package lsp-java-treemacs :after (treemacs))

;; need to configure local sshd for this to work
(use-package sudo-edit
  :ensure t)

;; this uses the forked version w/ a bug fix
;; https://raw.githubusercontent.com/eryx67/dired-toggle-sudo/master/dired-toggle-sudo.el
(require 'dired-toggle-sudo)
(define-key dired-mode-map (kbd "C-c C-s") 'dired-toggle-sudo)
(eval-after-load 'tramp
  '(progn
     ;; Allow to use: /sudo:user@host:/path/to/file
     (add-to-list 'tramp-default-proxies-alist
		  '(".*" "\\`.+\\'" "/ssh:%h:"))))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(defun bjm-swiper-recenter (&rest args)
  "recenter display after swiper"
  (recenter))

(use-package ivy
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (define-key ivy-minibuffer-map (kbd "C-c j") 'ivy-immediate-done)
    (setq ivy-height 10)
    (setq ivy-count-format "(%d/%d) ")
    (setq ivy-display-style 'fancy)
    (setq ivy-virtual-abbreviate 'full)
    (setq magit-completing-read-function 'ivy-completing-read)
   (define-key ivy-minibuffer-map (kbd "C-c j") 'ivy-immediate-done)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "C-j") 'ivy-switch-buffer)
    (add-hook 'view-mode-hook
              (function (lambda ()
                          (define-key view-mode-map (kbd "C-j") 'ivy-switch-buffer))))))

(use-package counsel
  :ensure t
  :config
  (progn
    (global-set-key (kbd "C-c i m") 'counsel-imenu)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "C-h f") 'counsel-describe-function)
    (global-set-key (kbd "C-j") 'ivy-switch-buffer)
    (global-set-key (kbd "M-y") 'counsel-yank-pop)
    (global-set-key (kbd "M-l") 'counsel-bookmark)))

  
;; good bye helm, hello swiper
(use-package swiper
  :ensure t
  :config
  (progn
    (global-set-key "\C-s" 'swiper)
    (global-set-key "\C-r" 'swiper)
    (advice-add 'swiper :after #'bjm-swiper-recenter)))

(use-package projectile
  :ensure t
  :config
  (progn
    (projectile-global-mode)
    (setq projectile-enable-caching nil)
    (global-set-key (kbd "C-f") 'projectile-command-map)
    (setq projectile-completion-system 'ivy)
    ;; (require 'counsel-projectile)
    (setq projectile-switch-project-action 'projectile-dired)
    (bind-key* "C-f l" 'projectile-find-file-other-window)
    ;; use counsel-ag instead of projectile-ag
    (defalias 'projectile-ag 'counsel-ag)))

;; i <3 projectile
(use-package counsel-projectile
  :ensure t
  :config
  (progn
    (defalias 'projectile-ag 'counsel-ag)
    (global-set-key (kbd "C-f p") 'counsel-projectile-switch-project)
    (setq counsel-projectile-switch-project-action 'counsel-projectile-switch-project-action-vc)))

(use-package ivy-hydra
  :ensure t)

(use-package ivy-posframe
  :ensure t
  :config
  (require 'ivy-posframe)
  ;; display at `ivy-posframe-style'
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-bottom-left)))
  ;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
  (ivy-posframe-mode 1))

;; there is a special case for Makefile mode that doesn't work properly with the indent-according-to-mode function
(defun bwb-indent-or-complete ()
    (interactive)
    (if (looking-at "\\_>")
        (company-complete-common)
      (if (derived-mode-p 'makefile-gmake-mode)
          (indent-for-tab-command)
        (indent-according-to-mode))))

;; == company-mode ==
(use-package company
  :ensure t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (global-set-key "\t" 'bwb-indent-or-complete)
  (setq company-idle-delay              0
	company-minimum-prefix-length   2
	company-show-numbers            t
	company-tooltip-limit           20
	company-dabbrev-downcase        nil
	)
  )

;; provides completion for elisp
(with-eval-after-load 'company
    (add-hook 'emacs-lisp-mode-hook
        '(lambda ()
         (require 'company-elisp)
         (push 'company-elisp company-backends))))

(use-package
  flycheck
  :ensure t
  :init
  (progn
    (add-hook 'after-init-hook #'global-flycheck-mode)
    (setq flycheck-highlighting-mode 'lines)))


(use-package
  smart-mode-line-powerline-theme
  :ensure t
  :config
  (progn
    (smart-mode-line-enable)))

(use-package smart-mode-line
  :ensure t
  :config
  (progn
    (sml/setup)
    (setq sml/theme 'dark)))

(use-package dired-hacks-utils
  :ensure t)

                   
;;(define-key my-keys-minor-mode-map (kbd "C-l") 'other-window)
(define-key global-map (kbd "C-l") 'other-window)

(setq-default fill-column 79)

;; This displays the current column number
(setq column-number-mode t)

;; disable backup
(setq backup-inhibited t)

;; disable auto save
(setq auto-save-default nil)

;; I am too cool to use scroll bar and tool bar!
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; don't disable menu bar and toolbar, useful for gdb
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(menu-bar-mode 0)

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (setq mac-command-key-is-meta t)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )

;; this is for magit
(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-`") 'magit-status))

;; start magit in full frame rather than split the frame
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer (if (and (derived-mode-p 'magit-mode)
                         (memq (with-current-buffer buffer major-mode)
                               '(magit-process-mode
                                 magit-revision-mode
                                 magit-diff-mode
                                 magit-stash-mode
                                 magit-status-mode)))
                    nil
                  '(display-buffer-same-window)))))


(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Berksfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Cheffile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Kitchenfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Berksfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Thorfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Kitchenfile$" . ruby-mode))


;;MARKDOWN
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

(setq auto-mode-alist (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.text" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.seed" . conf-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb" . conf-mode) auto-mode-alist))

(put 'scroll-left 'disabled nil)
(put 'downcase-region 'disabled nil)

;; turn off all menus
(progn
  ;; the toolbar and menubaris useful for gdb
  ;; (menu-bar-mode -1)
  ;; (when (fboundp 'tool-bar-mode)
  ;;   (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  (require 'saveplace)
  (setq-default save-place t)

  (show-paren-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq select-enable-clipboard t
        select-enable-primary t
        save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t
        save-place-file (concat user-emacs-directory "places")
        backup-directory-alist `(("." . ,(concat user-emacs-directory
                                                 "backups")))))

;; For some reason, org-mode ignores C-j, so we are adding it to the mode
;; also org-mode stopped respecting my normal keybindings after I replaced the
;; motherboard on my macbook pro so I had to specify the bindings here
(add-hook 'org-mode-hook ;; guessing
          '(lambda ()
             (setq org-hide-block-startup t)
             (local-set-key (kbd "ESC <down>") 'org-move-subtree-down)
             (local-set-key (kbd "ESC <up>") 'org-move-subtree-up)
             (local-set-key (kbd "ESC <left>") 'org-do-promote)
             (local-set-key (kbd "ESC <right>") 'org-do-demote)
             (local-set-key "\C-j" 'ivy-switch-buffer)
             (local-set-key (kbd "M-o") 'org-shiftright)))

;; custom handling of org-mode code blocks
(require 'org)
(add-to-list 'org-structure-template-alist
             (list "s" (concat "#+NAME: \n"
                               "#+BEGIN_SRC ?\n\n"
                               "#+END_SRC")))

;; https://github.com/suvayu/.emacs.d/blob/master/org-mode-config.el#L96
(setcdr (assoc "l" org-structure-template-alist)
        '("#+NAME: \n#+BEGIN_LOG\n?\n#+END_LOG"))


(defun ns-get-pasteboard ()
      "Returns the value of the pasteboard, or nil for unsupported formats."
     (condition-case nil
         (ns-get-selection-internal 'CLIPBOARD)
       (quit nil)))

;; gets rid of message "ls does not support --dired; see `dired-use-ls-dired' for more details." on os x
(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

;; this speeds up find-name-dired
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))


;; elpy python config
;; python config
;;(require 'elpy)
;; (elpy-enable)

;; (defalias 'activate 'pyvenv-activate)

;; (setq python-check-command "/usr/local/bin/flake8")
;; (setq python-shell-interpreter "ipython")
;; (setq python-shell-interpreter-args "--simple-prompt --pprint")

;; (put 'upcase-region 'disabled nil)

;; this is the only way to change the offset, customizing it otherwise
;; doesn't work
;; (add-hook 'python-mode-hook
;;    (function (lambda ()                  
;;                (setq python-indent-offset 4)
;;                (define-key python-mode-map (kbd "C-i") 'elpy-company-backend)
;;                (define-key python-mode-map (kbd "<tab>") 'indent-for-tab-command)
;;                (setq-local counsel-dash-docsets '("Python 2")))))


;; (use-package elpy :ensure t
;;   :config
;;   (progn
;;     (add-hook 'python-mode-hook 'flycheck-mode)
;;     (add-hook 'python-mode-hook 'elpy-mode)

;;     (with-eval-after-load 'elpy
;;       (setq elpy-rpc-python-command "python3")      
;;       (remove-hook 'elpy-modules 'elpy-module-flymake)
;;       (setq elpy-rpc-backend "jedi")
;;       (setq elpy-syntax-check-command "/home/hitman/bin/flake8")
;;       (elpy-set-test-runner 'elpy-test-pytest-runner)
;;       (defalias 'elpy-flymake-next-error 'flycheck-next-error)
;;       (defalias 'elpy-flymake-previous-error 'flycheck-previous-error))))

  
;;(add-to-list 'auto-mode-alist '("\\.py\\'" . elpy-mode))
;; (add-hook 'ansi-term-hook
;;     (function (lambda ()
;;       (define-key ansi-term-map (kbd "C-j") 'ivy-switch-buffer))))


;;(global-set-key (kbd "M-/") 'hippie-expand)

;; new python setup
;; https://github.com/emacs-lsp/lsp-python-ms
;; install dotnet sdk https://dotnet.microsoft.com/download/linux-package-manager/fedora28/sdk-current
;; sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
;; wget -q https://packages.microsoft.com/config/fedora/27/prod.repo
;; sudo mv prod.repo /etc/yum.repos.d/microsoft-prod.repo
;; sudo chown root:root /etc/yum.repos.d/microsoft-prod.repo
;; sudo dnf install dotnet-sdk-2.2
;; ln -sf /home/hitman/local/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer ~/bin
(use-package company-lsp :init
  (push 'company-lsp company-backends))

(use-package lsp-python-ms
  :ensure t
  :hook (python-mode . lsp)
  :demand
  :config
  (use-package lsp-mode :commands lsp)
  (use-package lsp-ui :commands lsp-ui-mode)
  (defun b-debug ()
    (interactive)
    (insert "import bpdb; bpdb.set_trace()\n")
    )
  (defun b-ipy ()
    (interactive)
    (insert "from IPython import embed; embed()\n")
    )
  (add-hook 'python-mode-hook
            (lambda()
              (lsp-ui-flycheck-enable t)
              ;; this causes incredible slowness for some reason
              (lsp-ui-sideline-enable nil)
              (setq python-shell-interpreter "/home/hitman/miniconda3/bin/python")
              ;; (setq python-shell-interpreter-args "run ipython --simple-prompt --pprint")
              (setq python-indent-offset 4)))
  (setq lsp-python-ms-executable "/home/hitman/local/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
  )


;; (defun my-go-mode-hook ()
;;   (setq tab-width 4)
;;   (setq indent-tabs-mode nil)
;;   (add-hook 'before-save-hook 'gofmt-before-save)
;;   (require 'auto-complete)
;;   (require 'go-autocomplete)
;;   (require 'auto-complete-config)
;;   (if (not (string-match "go" compile-command))
;;       (set (make-local-variable 'compile-command)
;;                       "go build -v && go test -v && go vet"))
;;   (local-set-key (kbd "M-.") 'godef-jump)
;;   (ac-config-default))
;; (add-hook 'go-mode-hook 'my-go-mode-hook)

;; (add-hook 'go-mode-hook (lambda ()
;;                           (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))
;; (add-hook 'go-mode-hook (lambda ()
;;                           (local-set-key (kbd "C-c C-a") 'go-import-add)))
;; (add-to-list 'load-path "~/pr/go/src/github.com/dougm/goflymake")
;; (require 'go-flymake)
;; (add-to-list 'load-path "~/pr/go/src/github.com/dougm/goflymake")
;; (require 'go-flycheck)

;; (setenv "GOPATH" "/Users/hitman/pr/go")

;; (setq-default show-trailing-whitespace nil)

;; (require 'go-eldoc)
;; (add-hook 'go-mode-hook 'go-eldoc-setup)

;; glogally removing whitespace pisses off ppl who review my PRs
;; (global-set-key (kbd "M-m") 'whitespace-cleanup)
(setq-default fill-column 80)

;; hotkeys for bookmarks, i never use these so commenting out
;; (global-set-key (kbd "C-c j") 'bookmark-jump)
;; (global-set-key (kbd "C-c b") 'bookmark-set)
;; (global-set-key (kbd "C-c l") 'bookmark-bmenu-list)
(global-set-key (kbd "M-t") 'revert-buffer)

;; (defun term-toggle-mode ()
;;   (interactive)
;;   (if (term-in-line-mode)
;;       (term-char-mode)
;;     (term-line-mode)))

;; (add-hook 'term-mode-hook
;;           (lambda ()
;;             (defmacro term-in-char-mode () '(eq (current-local-map) term-raw-map))
;;             (defmacro term-in-line-mode () '(not (term-in-char-mode)))
;;             (setq yas-dont-activate t)
;;             (define-key term-mode-map (kbd "M-j") 'term-toggle-mode)
;;             (define-key term-raw-map (kbd "M-j") 'term-toggle-mode)
;;             (define-key term-raw-map (kbd "C-l") 'other-window)
;;             (define-key term-raw-map (kbd "C-j") 'ivy-switch-buffer)))

;; (setq explicit-shell-file-name "/bin/bash")


;; orgmode setup
(require 'org)
(setq org-directory "/Users/hitman/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-capture-templates
'(("t" "Todo" entry (file+headline "~/org/notes.org" "Tasks")
   "* TODO %?\n  %i\n  %a")
  ("c" "Code" entry (file+headline "~/org/notes.org" "Code")
   "* Code %?\n  %i\n  %a\n %U")
  ("j" "Journal" entry (file+datetree "~/org/notes.org")
                "* %?\nEntered on %U\n  %i\n  %a")))
;; (define-key global-map (kbd "C-c c") 'org-capture)


;; temp org-mode keys
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

(setq org-log-done 'time)

(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "NOTGONNA(n)" "PLANNING(p)" "DONE(d)"))) 

(setq org-agenda-files (list "~/org/work.org"
                             "~/org/personal.org" 
                             "~/org/mygtd.org"))

(setq org-refile-targets '((org-agenda-files :maxlevel . 1)))


;; taken from http://wenshanren.org/?p=334
(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
          '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
            "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
            "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
            "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
            "scheme" "sqlite")))
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

(defun bwb-zap-whitespace-to-char ()
  "Kill all whitespace up to first non-whitespace char or end-of-line. Written by Yours Truly, BryanWB"
  (interactive)
  (set-mark (point))
  (let ((starting-point (point)))
        (kill-region starting-point
                     (progn
                       (search-forward-regexp "\\s-*" nil t nil)
                       (point)))))

(global-set-key (kbd "M-z") 'bwb-zap-whitespace-to-char)

(defun b3bp-strict ()
  "Inserts boilerplate for bash strict mode"
  (interactive)
  (beginning-of-line)
  (insert "# This is the unofficial Bash strict mode
# taken from https://github.com/kvz/bash3boilerplate/blob/master/main.sh#L14
# Exit on error. Append || true if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail\n"))

(defun b3bp-magic ()
  "Inserts magic variables"
  (interactive)
  (beginning-of-line)
  (insert "# Set magic variables for current file, directory, os, etc.
__dir=\"$(cd \"$(dirname \"${BASH_SOURCE[0]}\")\" && pwd)\"
__file=\"${__dir}/$(basename \"${BASH_SOURCE[0]}\")\"
__base=\"$(basename ${__file} .sh)\"\n"))

(require 'hydra)

(defhydra hydra-b3bp-menu (:color pink
                             :hint nil)
  "
Bash 3 Boiler Plate http://bash3boilerplate.sh/
^Actions^           
^^^^^^^^-----------------------------------------------------------------
_m_: magic variables
_s_: bash strict mode
"
  ("m" b3bp-magic)
  ("s" b3bp-strict)
  ("q" nil "cancel" :color blue))

(add-hook 'sh-mode-hook
          (lambda ()
            'flycheck-mode
            (define-key sh-mode-map (kbd "C-c C-n") 'flycheck-next-error)
            (define-key sh-mode-map (kbd "C-c C-p") 'flycheck-previous-error)
            (key-seq-define sh-mode-map "b3" 'hydra-b3bp-menu/body)
            ))

;; (add-to-list 'load-path "~/.emacs.d/vendor/emacs-gitlab")
;; (load "~/.emacs.d/vendor/emacs-gitlab/gitlab.el")

;;(require 'know-your-http-well)

(defalias 'cg 'counsel-git)
(defalias 'cgg 'counsel-git-grep)



;; dired customizations

(defun dired-deletion-no-confirm ()
  "Turn off delete confirmation."
  (interactive)
  (setq dired-deletion-confirmer '(lambda (x) t)))

;; navigation w/ j, k
(define-key dired-mode-map "j" 'dired-next-line)
(define-key dired-mode-map "k" 'dired-previous-line)

(define-key dired-mode-map "F" 'find-name-dired)

(define-key dired-mode-map "a"
    (lambda ()
      (interactive)
      (find-alternate-file "..")))

(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message
       "Size of all marked files: %s"
       (progn
         (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$")
         (match-string 1))))))

(define-key dired-mode-map (kbd "z") 'dired-get-size)

;; have two windows open and copy between them
(setq dired-dwim-target t)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "/Users/hitman/.emacs.d/bookmarks")
 '(custom-safe-themes
   '("6bc2bb2b8de7f68df77642b0615d40dc7850c2906b272d3f83a511f7195b07da" "8148420dfc7500b024735da3399f6d0b21f92bebeb1ff630f59422de719937c6" "5c9d6e9d35f1826a93985c2f4ed1c38151d99fd781e5764b1cfe5352f01345e5" "cc67c4d5fcd37a750975cd50fb2555c9654dc5b92b6fb04d65161bdc4d708b9b" "bcc6775934c9adf5f3bd1f428326ce0dcd34d743a92df48c128e6438b815b44f" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(flycheck-checkers
   '(tsx-tide typescript-tide ada-gnat asciidoctor asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint css-stylelint cuda-nvcc cwl d-dmd dockerfile-hadolint emacs-lisp emacs-lisp-checkdoc erlang-rebar3 erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck go-unconvert go-megacheck go-staticcheck groovy haml handlebars haskell-stack-ghc haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-standard json-jsonlint json-python-json json-jq jsonnet less less-stylelint llvm-llc lua-luacheck lua markdown-markdownlint-cli markdown-mdl nix nix-linter opam perl perl-perlcritic php php-phpmd php-phpcs processing proselint protobuf-protoc pug puppet-parser puppet-lint python-flake8 python-pylint python-pycompile python-mypy r-lintr racket rpm-rpmlint rst-sphinx rst ruby-rubocop ruby-reek ruby-rubylint ruby ruby-jruby rust-cargo rust rust-clippy scala scala-scalastyle scheme-chicken scss-lint scss-stylelint sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim slim-lint sql-sqlint systemd-analyze tcl-nagelfar tex-chktex tex-lacheck texinfo textlint typescript-tslint verilog-verilator vhdl-ghdl xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby javascript-tide jsx-tide))
 '(flycheck-highlighting-mode 'lines)
 '(gdb-many-windows t)
 '(global-flycheck-mode t)
 '(imenu-anywhere-buffer-filter-functions '(imenu-anywhere-same-project-p))
 '(package-selected-packages
   '(ivy-posframe ivy mips-mode ess rg cmake-mode yasnippet vterm-toggle lsp-ui lsp-mode elixir-yasnippets auto-yasnippet counsel flycheck-rust cargo eyebrowse perspeen lsp-imenu protobuf-mode dash dash-at-point ccls counsel-gtags company-gtags flymake-json smart-mode-line-powerline-theme js2-mode company-lsp lsp-javascript-typescript magit dockerfile-mode rjsx-mode rjsx indium js-comint helm-dash flymake-solidity go-mode projectile buffer-move dracula-theme pyvenv nov imenu-anywhere counsel-dash mmm-jinja2 company ivy-gitlab gitlab mvn dired-quick-sort hydra dired+ lorem-ipsum swiper all-the-icons-ivy org org-brain undo-tree avy f s beacon vhdl-tools company-c-headers web-mode nodejs-repl mmm-mode better-shell py-autopep8 toml-mode tide dired-hacks-utils yaml-mode use-package typescript tablist sudo-edit spinner seq restclient queue powershell pdf-tools ox-pandoc org-present org-mobile-sync multi-eshell markdown-mode magit-gh-pulls know-your-http-well key-seq json-mode jinja2-mode inf-ruby ido-vertical-mode hcl-mode golint go-eldoc go-autocomplete gist ggtags flycheck flx-ido exec-path-from-shell eshell-manual elpy dumb-jump counsel-projectile clojure-mode cl-lib-highlight ansible-doc ag))
 '(solidity-flycheck-solium-checker-active t t)
 '(typescript-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(variable-pitch ((t (:height 1.5 :family "Sans Serif")))))

;; adds /usr/local/bin to our PATH in eshell
;; (add-to-list 'exec-path "/usr/local/bin")

;; makes eshell behave better displaying lots of text
;; (setenv "PAGER" "cat")
;; (setenv "TERM" "xterm-256color")



;; copied from https://www.reddit.com/r/emacs/comments/5rnpsm/nice_hydra_to_set_frame_transparency/
(defun bwb--set-transparency (inc)
  "Increase or decrease the selected frame transparency"
  (let* ((alpha (frame-parameter (selected-frame) 'alpha))
         (next-alpha (cond ((not alpha) 100)
                           ((> (- alpha inc) 100) 100)
                           ((< (- alpha inc) 0) 0)
                           (t (- alpha inc)))))
    (set-frame-parameter (selected-frame) 'alpha next-alpha)))

(defhydra hydra-transparency (:columns 2)
  "
ALPHA : [ %(frame-parameter nil 'alpha) ]
"
  ("j" (lambda () (interactive) (bwb--set-transparency +1)) "+ more")
  ("k" (lambda () (interactive) (bwb--set-transparency -1)) "- less")
  ("J" (lambda () (interactive) (bwb--set-transparency +10)) "++ more")
  ("K" (lambda () (interactive) (bwb--set-transparency -10)) "-- less")
  ("=" (lambda (value) (interactive "nTransparency Value 0 - 100 opaque:")
         (set-frame-parameter (selected-frame) 'alpha value)) "Set to ?" :color blue))


(defun bwb--set-fontsize (inc)
  "Increase or decrease the selected frame transparency"
  (text-scale-adjust inc))
  
(defhydra hydra-fontsize (:columns 2)
  "
SIZE : 
"
  ("j" (lambda () (interactive) (bwb--set-fontsize +0.25)) "+ more")
  ("k" (lambda () (interactive) (bwb--set-fontsize -0.25)) "- less")
  ("J" (lambda () (interactive) (bwb--set-fontsize +1)) "++ more")
  ("K" (lambda () (interactive) (bwb--set-fontsize -1)) "-- less"))


;; C, C++ configuration
;; mostly taken from here https://github.com/MaskRay/ccls/wiki/lsp-mode
(use-package counsel-gtags
  :ensure t
  :defer t
  :init
  (setq tags-file-name "GTAGS"))

(use-package ccls
  :ensure t
  :defer t
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp)))
  :init
  (use-package lsp-mode :commands lsp)
  (use-package lsp-ui :commands lsp-ui-mode)
  (use-package company-lsp :commands company-lsp)
  (setq lsp-prefer-flymake nil)
  (setq xref-backend-functions 'lsp--xref-backend)
  (setq ccls-executable "/home/hitman/bin/ccls"))

;; ;; use indium instead of nodejs-repl
;; ;; http://indium.readthedocs.io/en/latest/index.html
;; (use-package indium
;;   :ensure t
;;   :config
;;   (progn
;;     (add-hook 'js-mode-hook #'indium-interaction-mode)
;;     (define-key indium-interaction-mode-map (kbd "C-c C-c") 'indium-eval-region)))



(defun setup-tide-mode ()
  (interactive)
  ;;  (setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))
  (tide-setup)
  (if (file-exists-p (concat tide-project-root "node_modules/typescript/bin/tsserver"))
    (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")
    (setq tide-tsserver-executable "/home/hitman/.config/yarn/global/node_modules/.bin/tsserver"))
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (setq tide-format-options '(:indentSize 2 :tabSize 2 :insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (local-set-key (kbd "C-c d") 'tide-documentation-at-point)
  (company-mode +1))

;; typescript setup
(use-package tide
  :ensure t
  :config
  (progn
    (company-mode +1)
    ;; aligns annotation to the right hand side
    (setq company-tooltip-align-annotations t)
    (add-hook 'typescript-mode-hook #'setup-tide-mode)
    (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
  ))

;; use web-mode + tide-mode for javascript instead
(use-package js2-mode
  :ensure t
  :config
  (progn
    (add-hook 'js2-mode-hook #'setup-tide-mode)
    ;; configure javascript-tide checker to run after your default javascript checker
    (setq js2-basic-offset 2)
    (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))))

;; (add-to-list 'interpreter-mode-alist '("node" . js2-mode))

;; use json-mode from https://github.com/joshwnj/json-mode for json instead of js-mode or js2-mode
(use-package json-mode
  :ensure t
  :config
  (progn
    (flycheck-add-mode 'json-jsonlint 'json-mode)
    (add-hook 'json-mode-hook 'flycheck-mode)
    (setq js-indent-level 2)
    (add-to-list 'auto-mode-alist '("\\.json" . json-mode))))

(use-package web-mode
  :ensure t
  :config
  (progn
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.js" . web-mode))
    ;; this magic incantation fixes highlighting of jsx syntax in .js files
    (setq web-mode-content-types-alist
          '(("jsx" . "\\.js[x]?\\'")))
    (add-hook 'web-mode-hook
              (lambda ()
                (setq web-mode-code-indent-offset 2)
                (when (string-equal "tsx" (file-name-extension buffer-file-name))
                  (setup-tide-mode))
                (when (string-equal "jsx" (file-name-extension buffer-file-name))
                  (setup-tide-mode))
                (when (string-equal "js" (file-name-extension buffer-file-name))
                  (progn
                    (setup-tide-mode)
                    (with-eval-after-load 'flycheck
                      (flycheck-add-mode 'typescript-tslint 'web-mode)
                      (flycheck-add-mode 'javascript-tide 'web-mode))))))
    ))
    ;; enable typescript-tslint checker
    

;; (add-to-list 'auto-mode-alist '("\\.html" . web-mode))

(add-to-list 'exec-path "/home/hitman/.config/yarn/global/node_modules/.bin")

;; configuration for nand2tetris exercises
;; https://github.com/CestDiego/nand2tetris.el
;; (use-package nand2tetris
;;   :ensure t
;;   :config
;;   (progn
;;     (add-hook 'nand2tetris-mode 'company-mode)
;;     (add-hook 'nand2tetris-mode 'company-nand2tetris)))

;; (use-package company-nand2tetris
;;   :ensure t)
                          
;; (use-package nand2tetris-assembler
;;   :ensure t)


;; (add-to-list 'auto-mode-alist '("\\.hdl$" . nand2tetris-mode))


(defun bwb-coderef ()
  "Get a relative path to current file and selected text"
  (interactive)
  (let* ((host gitlab-host)
         (branch (gitlab--get-branch))
         (group+name (gitlab--get-project-group+name))
         (path (gitlab--get-current-path-relative))
         (linenums (gitlab--get-line-nums)))
    (kill-new (format "%s%s" path linenums)))
  (pop-mark))


(defun bwb-orglink ()
  "Creates an org-mode link to file w/ correct line number"
  (interactive)
  (let ((link-name (read-string "Enter link name: ")))
    (kill-new
     (format "[[file:%s::%s][%s]]"
             (buffer-file-name)
             (line-number-at-pos (point))
             link-name)))
  (pop-mark))

;; copied from 
;; http://cestlaz.github.io/posts/using-emacs-34-ibuffer-emmet/#.WUQQcxN95E5
;; (global-set-key (kbd "C-x C-b") 'ibuffer)
;; (setq ibuffer-saved-filter-groups
;;       (quote (("default"
;;                ("magit" (mode . magit-mode))
;; 	       ("dired" (mode . dired-mode))
;; 	       ("org" (name . "^.*org$"))

;; 	       ;;("web" (or (mode . web-mode) (mode . js2-mode)))
;; 	       ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
;; 	       ("programming" (or
;; 			       (mode . python-mode)
;; 			       (mode . c++-mode)))
;; 	       ("emacs" (or
;; 			 (name . "^\\*scratch\\*$")
;; 			 (name . "^\\*Messages\\*$")))
;; 	       ))))
;; (add-hook 'ibuffer-mode-hook
;; 	  (lambda ()
;; 	    (ibuffer-auto-mode 1)
;; 	    (ibuffer-switch-to-saved-filter-groups "default")))

;; don't show these
					;(add-to-list 'ibuffer-never-show-predicates "zowie")
;; Don't show filter groups if there are no buffers in that group
(setq ibuffer-show-empty-filter-groups nil)

;; Don't ask for confirmation to delete marked buffers
(setq ibuffer-expert t)


;; copied from http://cestlaz.github.io/posts/using-emacs-33-projectile-jump/#.WUocFsllNE5
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
	 ("M-g j" . dumb-jump-go)
	 ("M-g x" . dumb-jump-go-prefer-external)
	 ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (progn
            (setq dumb-jump-force-searcher 'rg)
            (setq dumb-jump-selector 'ivy))
  :init
  (dumb-jump-mode)
  :ensure)


;; eshell stuff
;; (setenv "JAVA_HOME"
;;         "/Library/Java/JavaVirtualMachines/jdk1.8.0_73.jdk/Contents/Home")


;; Protect against accident pushes to upstream
;; copied from https://github.com/magit/magit/wiki/Tips-and-Tricks#ask-for-confirmation-before-pushing-to-originmaster
(defadvice magit-push-current-to-upstream
    (around my-protect-accidental-magit-push-current-to-upstream)
  "Protect against accidental push to upstream.

Causes `magit-git-push' to ask the user for confirmation first."
  (let ((my-magit-ask-before-push t))
    ad-do-it))

(defadvice magit-git-push (around my-protect-accidental-magit-git-push)
  "Maybe ask the user for confirmation before pushing.

Advice to `magit-push-current-to-upstream' triggers this query."
  (if (bound-and-true-p my-magit-ask-before-push)
      ;; Arglist is (BRANCH TARGET ARGS)
      (if (yes-or-no-p (format "Push %s branch upstream to %s? "
                               (ad-get-arg 0) (ad-get-arg 1)))
          ad-do-it
        (error "Push to upstream aborted by user"))
    ad-do-it))

(ad-activate 'magit-push-current-to-upstream)
(ad-activate 'magit-git-push)


;; eww settings
;; wrap lines after 100 chars
(setq shr-width 100)


;; ruby configuration
;; https://raw.githubusercontent.com/howardabrams/dot-files/master/emacs-ruby.org
(use-package ruby-mode
      :ensure t
      :mode "\\.rb\\'"
      :mode "Rakefile\\'"
      :mode "Gemfile\\'"
      :mode "Berksfile\\'"
      :mode "Vagrantfile\\'"
      :interpreter "ruby"

      :init
      (progn
        (setq ruby-indent-level 2
              ruby-indent-tabs-mode nil)
        (add-hook 'ruby-mode 'superword-mode)
        (add-hook 'ruby-mode-hook
                  (lambda ()
                    (setq-local counsel-dash-docsets '("Ruby" "Chef")))))

      :bind
      (([(meta down)] . ruby-forward-sexp)
       ([(meta up)]   . ruby-backward-sexp)
       (("C-c C-e"    . ruby-send-region))))  ;; Rebind since Rubocop uses C-c C-r

(use-package web-mode
      :ensure t
      :mode "\\.erb\\'")

(use-package rubocop
      :ensure t
      :init
      (add-hook 'ruby-mode-hook 'rubocop-mode)
      :diminish rubocop-mode)

(use-package inf-ruby
      :ensure t
      :init
      (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode))


;; (use-package counsel-dash
;;   :ensure t
;;   :config
;;   (progn
;;     (setq counsel-dash-docsets-path "~/.docset")
;;     (setq counsel-dash-docsets-url "https://raw.github.com/Kapeli/feeds/master")
;;     (setq counsel-dash-min-length 3)
;;     (setq counsel-dash-candidate-format "%d %n (%t)")
;;     (setq counsel-dash-enable-debugging nil)
;;     (setq counsel-dash-browser-func 'eww-browse-url)
;;     (setq counsel-dash-ignored-docsets nil)))
  

;; https://github.com/vspinu/imenu-anywhere
;; only works w/ open buffers but damn it is nice
(use-package imenu-anywhere
  :ensure t
  :config
  (progn
    (global-set-key (kbd "C-.") #'imenu-anywhere)))
    

;; unsettings - these are keybinding I do not use and their default usages confuse me

;; undo capitalize-word as i type it by accident
;; and often don't notice the change
;;(global-unset-key (kbd "M-c"))

;; transpose-chars - this can cause errors
(global-unset-key (kbd "C-t"))

;; transpose-lines - this can cause errors
(global-unset-key (kbd "C-x C-t"))

;; read epubs!
;; requires emacs be compiled wiht libxml2 support
;; brew info emacs indicates this
(use-package nov
  :ensure t
  :config
  (push '("\\.epub\\'" . nov-mode) auto-mode-alist))


;; https://draculatheme.com/emacs/
(use-package dracula-theme 
  :ensure t
  :config
  (progn
    (load-theme 'dracula t)))

;; (defun eshell-here ()
;;   "Opens up a new shell in the directory associated with the
;; current buffer's file. The eshell is renamed to match that
;; directory to make multiple eshell windows easier."
;;   (interactive)
;;   (let* ((parent (if (buffer-file-name)
;;                      (file-name-directory (buffer-file-name))
;;                    default-directory))
;;          (height (/ (window-total-height) 3))
;;          (name   (car (last (split-string parent "/" t)))))
;;     (split-window-vertically (- height))
;;     (other-window 1)
;;     (eshell "new")
;;     (rename-buffer (concat "*eshell: " name "*"))

;;     (insert (concat "ls"))
;;     (eshell-send-input)))


(defun remove-newlines-in-region ()
  "Removes all newlines in the region."
  (interactive)
  (save-restriction
    (narrow-to-region (point) (mark))
    (goto-char (point-min))
    (while (search-forward "\n" nil t) (replace-match "" nil t))))


;; (bind-key "C-!" 'eshell-here)

;; https://emacs.stackexchange.com/a/33252
;; node repl vomits on the backspace key
;; (require 'term)
;; (defun term-handle-ansi-escape (proc char)
;;   (cond
;;    ((or (eq char ?H)  ;; cursor motion (terminfo: cup,home)
;;     ;; (eq char ?f) ;; xterm seems to handle this sequence too, not
;;     ;; needed for now
;;     )
;;     (when (<= term-terminal-parameter 0)
;;       (setq term-terminal-parameter 1))
;;     (when (<= term-terminal-previous-parameter 0)
;;       (setq term-terminal-previous-parameter 1))
;;     (when (> term-terminal-previous-parameter term-height)
;;       (setq term-terminal-previous-parameter term-height))
;;     (when (> term-terminal-parameter term-width)
;;       (setq term-terminal-parameter term-width))
;;     (term-goto
;;      (1- term-terminal-previous-parameter)
;;      (1- term-terminal-parameter)))
;;    ;; \E[A - cursor up (terminfo: cuu, cuu1)
;;    ((eq char ?A)
;;     (term-handle-deferred-scroll)
;;     (let ((tcr (term-current-row)))
;;       (term-down
;;        (if (< (- tcr term-terminal-parameter) term-scroll-start)
;;        ;; If the amount to move is before scroll start, move
;;        ;; to scroll start.
;;        (- term-scroll-start tcr)
;;      (if (>= term-terminal-parameter tcr)
;;          (- tcr)
;;        (- (max 1 term-terminal-parameter)))) t)))
;;    ;; \E[B - cursor down (terminfo: cud)
;;    ((eq char ?B)
;;     (let ((tcr (term-current-row)))
;;       (unless (= tcr (1- term-scroll-end))
;;     (term-down
;;      (if (> (+ tcr term-terminal-parameter) term-scroll-end)
;;          (- term-scroll-end 1 tcr)
;;        (max 1 term-terminal-parameter)) t))))
;;    ;; \E[C - cursor right (terminfo: cuf, cuf1)
;;    ((eq char ?C)
;;     (term-move-columns
;;      (max 1
;;       (if (>= (+ term-terminal-parameter (term-current-column)) term-width)
;;           (- term-width (term-current-column)  1)
;;         term-terminal-parameter))))
;;    ;; \E[D - cursor left (terminfo: cub)
;;    ((eq char ?D)
;;     (term-move-columns (- (max 1 term-terminal-parameter))))
;;    ((eq char ?G)
;;     (term-move-columns (- (max 0 (min term-width term-terminal-parameter))
;;                           (term-current-column))))
;;    ;; \E[J - clear to end of screen (terminfo: ed, clear)
;;    ((eq char ?J)
;;     (term-erase-in-display term-terminal-parameter))
;;    ;; \E[K - clear to end of line (terminfo: el, el1)
;;    ((eq char ?K)
;;     (term-erase-in-line term-terminal-parameter))
;;    ;; \E[L - insert lines (terminfo: il, il1)
;;    ((eq char ?L)
;;     (term-insert-lines (max 1 term-terminal-parameter)))
;;    ;; \E[M - delete lines (terminfo: dl, dl1)
;;    ((eq char ?M)
;;     (term-delete-lines (max 1 term-terminal-parameter)))
;;    ;; \E[P - delete chars (terminfo: dch, dch1)
;;    ((eq char ?P)
;;     (term-delete-chars (max 1 term-terminal-parameter)))
;;    ;; \E[@ - insert spaces (terminfo: ich)
;;    ((eq char ?@)
;;     (term-insert-spaces (max 1 term-terminal-parameter)))
;;    ;; \E[?h - DEC Private Mode Set
;;    ((eq char ?h)
;;     (cond ((eq term-terminal-parameter 4)  ;; (terminfo: smir)
;;        (setq term-insert-mode t))
;;       ;; ((eq term-terminal-parameter 47) ;; (terminfo: smcup)
;;       ;; (term-switch-to-alternate-sub-buffer t))
;;       ))
;;    ;; \E[?l - DEC Private Mode Reset
;;    ((eq char ?l)
;;     (cond ((eq term-terminal-parameter 4)  ;; (terminfo: rmir)
;;        (setq term-insert-mode nil))
;;       ;; ((eq term-terminal-parameter 47) ;; (terminfo: rmcup)
;;       ;; (term-switch-to-alternate-sub-buffer nil))
;;       ))

;;    ;; Modified to allow ansi coloring -mm
;;    ;; \E[m - Set/reset modes, set bg/fg
;;    ;;(terminfo: smso,rmso,smul,rmul,rev,bold,sgr0,invis,op,setab,setaf)
;;    ((eq char ?m)
;;     (when (= term-terminal-more-parameters 1)
;;       (when (>= term-terminal-previous-parameter-4 0)
;;     (term-handle-colors-array term-terminal-previous-parameter-4))
;;       (when (>= term-terminal-previous-parameter-3 0)
;;     (term-handle-colors-array term-terminal-previous-parameter-3))
;;       (when (>= term-terminal-previous-parameter-2 0)
;;     (term-handle-colors-array term-terminal-previous-parameter-2))
;;       (term-handle-colors-array term-terminal-previous-parameter))
;;     (term-handle-colors-array term-terminal-parameter))

;;    ;; \E[6n - Report cursor position (terminfo: u7)
;;    ((eq char ?n)
;;     (term-handle-deferred-scroll)
;;     (process-send-string proc
;;              ;; (terminfo: u6)
;;              (format "\e[%s;%sR"
;;                  (1+ (term-current-row))
;;                  (1+ (term-horizontal-column)))))
;;    ;; \E[r - Set scrolling region (terminfo: csr)
;;    ((eq char ?r)
;;     (term-set-scroll-region
;;      (1- term-terminal-previous-parameter)
;;      (1- term-terminal-parameter)))
;;    (t)))


;; only ask once to delete a set of directories
(setq dired-recursive-deletes 'always)


(defvar bwb-timestamp-format "%Y-%m-%dT%H:%M:%SZ"
  "Format of date to insert with `bjk-timestamp' function
%Y-%m-%d %H:%M will produce something of the form YYYY-MM-DD HH:MM
Do C-h f on `format-time-string' for more info")


(defun bwb-timestamp ()
  "Insert a timestamp at the current point.
Note no attempt to go to beginning of line and no added carriage return.
Uses `bwb-timestamp-format' for formatting the date/time."
       (interactive)
       (insert (format-time-string bwb-timestamp-format (current-time)))
       )

;; https://www.reddit.com/r/emacs/comments/bjrd3f/how_can_i_unlock_folder_from_lspmode_blacklist/?ref=readnext
(defun bwb-clear-lsp-blacklist ()
  (interactive)
  (setf (lsp-session-folders-blacklist (lsp-session)) nil)
  (lsp--persist-session (lsp-session)))

;; require confirmation before closing emacs
(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Do you really want to exit Emacs? "))
          'append) 


;; desktop-save
;; https://www.emacswiki.org/emacs/Desktop
;; http://pragmaticemacs.com/emacs/save-window-layouts-with-ivy-view/
;;(desktop-save-mode 1)
;;(add-to-list 'desktop-globals-to-save 'ivy-views)


;; Rust setup
;; taken largely from here https://www.mortens.dev/blog/emacs-and-the-language-server-protocol/
(use-package cargo :ensure t)
(use-package flycheck-rust :ensure t)

(use-package rust-mode
  :requires cargo hydra flycheck-rust
  :config
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil)))
  (setq rust-format-on-save t)
  (add-to-list 'auto-mode-alist '("\\.rs$" . rust-mode))
  (add-to-list 'exec-path "/home/hitman/.cargo/bin")
  ;; (with-eval-after-load 'flycheck
  ;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
  (with-eval-after-load 'lsp
    (add-hook 'rust-mode-hook #'lsp)))
  


(defun bwb-makefile ()
  "Inserts sensible Makefile preamble based on https://tech.davis-hansson.com/p/make/"
  (interactive)
  (beginning-of-line)
  (insert "SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >
"))

(use-package rg
  :ensure t)


(add-to-list 'auto-mode-alist '("\\.g4$" . antlr-mode))
;;; init.el ends here



