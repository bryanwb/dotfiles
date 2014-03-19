;; This is an emacs file I created to customize emacs
;; The settings should take effect on emacs start-up

(add-to-list 'load-path "~/.emacs.d/")
(require 'org)
(require 'uniquify)
;;(add-to-list 'load-path "~/.emacs.d/emacs-elixir")
;;(require 'elixir-mode-setup)
;;(elixir-mode-setup)

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
(add-to-list 'load-path "~/.emacs.d/magit")
(require 'magit)
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

(add-to-list 'load-path "~/.emacs.d/emacs-pry")
(require 'pry)

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
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(progn
  (ido-mode t)
  (setq ido-enable-flex-matching t)

  (menu-bar-mode -1)
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

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

(require 'tramp)
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

;;(add-hook 'dired-load-hook
;;            (function (lambda () (load "dired-plus"))))
