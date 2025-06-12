;; colorscheme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'masterj t)


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

;; auto save
(add-to-list 'load-path "~/.emacs.d/site-lisp/autosave") ; add auto-save to your load-path
(require 'auto-save)
(auto-save-enable)

(setq auto-save-silent t)   ; quietly save
(setq auto-save-delete-trailing-whitespace t)  ; automatically delete spaces at the end of the line when saving
;;; custom predicates if you don't want auto save.
;;; disable auto save mode when current filetype is an gpg file.
(setq auto-save-disable-predicates
      '((lambda ()
      (string-suffix-p
      "gpg"
      (file-name-extension (buffer-name)) t))))
