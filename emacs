;; This is an emacs file I created to customize emacs
;; The settings should take effect on emacs start-up

(add-to-list 'load-path "~/.emacs.d/")
(require 'org)

(setq fill-column 79)
(setq-default auto-fill-function 'do-auto-fill)

;; This enables use of the X clipboard for copying and pasting
(setq x-select-enable-clipboard t)

;; This displays the current column number
(setq column-number-mode t)

;; disable backup
(setq backup-inhibited t)

;; disable auto save
(setq auto-save-default nil)

;; I am too cool to use scroll bar and tool bar!
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(menu-bar-mode 0)


;; this is the emacs starter kis
(require 'package)
(add-to-list 'package-archives
'("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode
keymap.")

(define-key my-keys-minor-mode-map (kbd "C-l") 'other-window)
(define-key my-keys-minor-mode-map (kbd "<f2>") 'multi-term)
(define-key my-keys-minor-mode-map (kbd "<f3>") 'multi-term-prev)
(define-key my-keys-minor-mode-map (kbd "<f4>") 'multi-term-next)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major
  modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

(require 'inf-ruby)
(autoload 'run-ruby "inf-ruby"
          "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
          "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
          (inf-ruby-keys)
          ))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
