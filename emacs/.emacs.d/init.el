(add-to-list 'load-path "~/.emacs.d/config")
(load "options")
(load "keymaps")


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

;; lang settins
;; C
(add-to-list 'load-path "~/.emacs.d/lang/C")
(require 'simpc-mode)
;; Automatically enabling simpc-mode on files with extensions like .h, .c, .cpp, .hpp
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
;; GO
(add-to-list 'load-path "~/.emacs.d/lang/go")
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
