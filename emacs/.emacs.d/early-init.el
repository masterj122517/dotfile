;; colorscheme
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/everforest")
(load-theme 'everforest-hard-dark t)
;; vim-like
(add-to-list 'load-path "~/.emacs.d/site-lisp/evil")
(add-to-list 'load-path (expand-file-name "site-lisp/annalist.el" user-emacs-directory))
(add-to-list 'load-path "~/.emacs.d/site-lisp/evil-collection")
(setq evil-want-C-u-scroll t)
(setq evil-want-integration t) ;; This is optional since it's already set to t by default.
(setq evil-want-keybinding nil)
(when (require 'evil-collection nil t)
  (evil-collection-init))
(require 'evil)
(evil-mode 1)
(require 'annalist)  
(require 'evil-collection)
(evil-collection-init)

(add-to-list 'load-path "~/.emacs.d/site-lisp/evil-surround")
(require 'evil-surround)

(global-evil-surround-mode 1)


;; emacs tools
(add-to-list 'load-path "~/.emacs.d/site-lisp/smex")
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
