;; This is an emacs file I created to customize emacs
;; The settings should take effect on emacs start-up

(require 'org)

(setq-default fill-column 100)
;;(setq-default auto-fill-function 'do-auto-fill)

;; This enables use of the X clipboard for copying and pasting
(setq x-select-enable-clipboard t)

;; This displays the current column number
(setq column-number-mode t)

;; disable backup
(setq backup-inhibited t)

;; disable auto save
(setq auto-save-default nil)

;; set background and foreground colors
(set-background-color "black")
(set-foreground-color "white")

;; I am too cool to use scroll bar and tool bar!
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(menu-bar-mode 0)

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )


;; this is for magit
(global-set-key (kbd "M-a") 'magit-status)

;; this is the emacs starter kis
(require 'package)
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives
'("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)


(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode
keymap.")

(define-key my-keys-minor-mode-map (kbd "C-l") 'other-window)
(define-key my-keys-minor-mode-map (kbd "<f1>") 'eshell)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major
  modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;;(add-hook 'ruby-mode-hook
;;          '(lambda ()
;;          (inf-ruby-keys)
;;          ))


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
;; (require 'ruby-block)
;; (ruby-block-mode t)

;;(add-to-list 'load-path "~/.emacs.d/emacs-pry")
;;(require 'pry)

;;MARKDOWN
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.text" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.seed" . conf-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb" . conf-mode) auto-mode-alist))

(put 'scroll-left 'disabled nil)
(put 'ido-exit-minibuffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(frame-background-mode (quote dark))
 '(python-indent-offset 2)
 '(python-shell-interpreter "ipython"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)

(progn
  (ido-mode t)
  (setq ido-enable-flex-matching t)

  (menu-bar-mode -1)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;;  (require 'uniquify)
;;  (setq uniquify-buffer-name-style 'forward)

  (require 'saveplace)
  (setq-default save-place t)

  (global-set-key (kbd "M-/") 'hippie-expand)
  (global-set-key (kbd "C-x C-b") 'ibuffer)

  (global-set-key (kbd "C-s") 'isearch-forward-regexp)
  (global-set-key (kbd "C-r") 'isearch-backward-regexp)
  (global-set-key (kbd "C-M-s") 'isearch-forward)
  (global-set-key (kbd "C-M-r") 'isearch-backward)

  (show-paren-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq x-select-enable-clipboard t
        x-select-enable-primary t
        save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t
        save-place-file (concat user-emacs-directory "places")
        backup-directory-alist `(("." . ,(concat user-emacs-directory
                                                 "backups")))))

(require 'whitespace)
(setq whitespace-style '(face tabs trailing lines-tail))
   
;; face for long lines' tails
(set-face-attribute 'whitespace-line nil
                    :background "red1"
                    :foreground "yellow"
                    :weight 'bold)

;; face for Tabs
(set-face-attribute 'whitespace-tab nil
                    :background "red1"
                    :foreground "yellow"
                    :weight 'bold)

(setq whitespace-line-column 200)

(add-hook 'python-mode-hook 'whitespace-mode)
(add-hook 'ruby-mode-hook 'whitespace-mode)
;;(add-hook 'ruby-mode-hook 'ruby-electric-mode)

(defun ns-get-pasteboard ()
      "Returns the value of the pasteboard, or nil for unsupported formats."
     (condition-case nil
         (ns-get-selection-internal 'CLIPBOARD)
       (quit nil)))

;; gets rid of message "ls does not support --dired; see `dired-use-ls-dired' for more details." on os x
(when (eq system-type 'darwin)
  (require 'ls-lisp)
    (setq ls-lisp-use-insert-directory-program nil))


(defun visit-term-buffer ()
       "Create or visit a terminal buffer."
       (interactive)
       (if (not (get-buffer "*ansi-term*"))
           (progn
                (split-window-sensibly (selected-window))
                (other-window 1)
                (ansi-term (getenv "SHELL")))
                (switch-to-buffer-other-window "*ansi-term*")))

(global-set-key (kbd "C-c t") 'visit-term-buffer)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(require 'engine-mode)
(engine-mode t)
(defengine github
  "https://github.com/search?ref=simplesearch&q=%s")
  
(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  "g")   

;; python config
(elpy-enable)
(require 'yasnippet)
(yas-global-mode 1)

;; this is the only way to change the offset, customizing it otherwise
;; doesn't work
(add-hook 'python-mode-hook
   (function (lambda ()                  
      (setq python-indent-offset 2))))