;; This is an emacs file I created to customize emacs
;; The settings should take effect on emacs start-up

(add-to-list 'load-path "~/.emacs.d/")
(require 'org)
'(width . 79)

;; This enables use of the X clipboard for copying and pasting
(setq x-select-enable-clipboard t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/org/notes.org" "~/org/organizer.org" "~/org/mygtd.org" "~/org/meetings.org")))
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 20) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t)(set-background-color "white")))))


;; This displays the current column number
(setq column-number-mode t)

;; I am too cool to use scroll bar and tool bar!
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(menu-bar-mode 0)


;;to set background color to black(set-background-color "black")
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :family "adobe-courier"))))
 '(background "blue")
 '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "Turquoise"))))
 '(font-lock-comment-face ((t (:foreground "MediumAquamarine"))))
 '(font-lock-constant-face ((((class color) (background dark)) (:bold t :foreground "DarkOrchid"))))
 '(font-lock-doc-string-face ((t (:foreground "green2"))))
 '(font-lock-function-name-face ((t (:foreground "SkyBlue"))))
 '(font-lock-keyword-face ((t (:bold t :foreground "CornflowerBlue"))))
 '(font-lock-preprocessor-face ((t (:italic nil :foreground "CornFlowerBlue"))))
 '(font-lock-reference-face ((t (:foreground "DodgerBlue"))))
 '(font-lock-string-face ((t (:foreground "LimeGreen"))))
 '(font-lock-type-face ((t (:foreground "#9290ff"))))
 '(font-lock-variable-name-face ((t (:foreground "PaleGreen"))))
 '(font-lock-warning-face ((((class color) (background dark)) (:foreground "yellow" :background "red"))))
 '(highlight ((t (:background "CornflowerBlue"))))
 '(list-mode-item-selected ((t (:background "gold"))))
 '(makefile-space-face ((t (:background "wheat"))))
 '(mode-line ((t (:background "Navy"))))
 '(paren-match ((t (:background "darkseagreen4"))))
 '(region ((t (:background "DarkSlateBlue"))))
 '(show-paren-match ((t (:foreground "black" :background "wheat"))))
 '(show-paren-mismatch ((((class color)) (:foreground "white" :background "red"))))
 '(speedbar-button-face ((((class color) (background dark)) (:foreground "green4"))))
 '(speedbar-directory-face ((((class color) (background dark)) (:foreground "khaki"))))
 '(speedbar-file-face ((((class color) (background dark)) (:foreground "cyan"))))
 '(speedbar-tag-face ((((class color) (background dark)) (:foreground "Springgreen"))))
 '(vhdl-speedbar-architecture-selected-face ((((class color) (background dark)) (:underline t :foreground "Blue"))))
 '(vhdl-speedbar-entity-face ((((class color) (background dark)) (:foreground "darkGreen"))))
 '(vhdl-speedbar-entity-selected-face ((((class color) (background dark)) (:underline t :foreground "darkGreen"))))
 '(vhdl-speedbar-package-face ((((class color) (background dark)) (:foreground "black"))))
 '(vhdl-speedbar-package-selected-face ((((class color) (background dark)) (:underline t :foreground "black"))))
 '(widget-field ((((class grayscale color) (background light)) (:background "DarkBlue")))))

(put 'upcase-region 'disabled nil)

;; this is the emacs starter kis
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)






