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
;; Rust
(add-to-list 'load-path "~/.emacs.d/lang/rust-mode")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;; markdown-mode
(add-to-list 'load-path "~/.emacs.d/site-lisp/markdown-mode")

;; lsp-bridge

(add-to-list 'load-path "~/.emacs.d/site-lisp/lsp-bridge")
(add-to-list 'load-path
              "~/.emacs.d/site-lisp/yasnippet")

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)
