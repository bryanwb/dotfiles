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

;; I am too cool to use scroll bar and tool bar!
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(menu-bar-mode 0)


;; this is the emacs starter kis
(require 'package)
(add-to-list 'package-archives
'("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(global-set-key (kbd "C-m") 'other-window)                


