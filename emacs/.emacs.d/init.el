(add-to-list 'load-path "~/.emacs.d/config")
(load "options")
(load "keymaps")


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
