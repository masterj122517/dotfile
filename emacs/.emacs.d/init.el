(setq inhibit-startup-screen t)

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(setq package-check-signature nil)
(require 'package)

(unless (bound-and-true-p package-initalized)
  (package-initialize))

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
  
(eval-and-compile)
(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(setq use-package-always-demand nil)
(setq use-package-expand-minimally t)
(setq use-package-verbose t)
;; Appearance
(use-package gruber-darkder
    :init (load-theme 'gruber-darker t))
(set-frame-font "Iosevka-20" nil t)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(defun display-startup-echo-area-message ()
  (message "Let the hacking begin!"))


;; Evil Mode 
;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)
(put 'dired-find-alternate-file 'disabled nil)

;; ido
(unless (package-installed-p 'smex)
  (package-install 'smex))

(unless (package-installed-p 'ido-completing-read+)
  (package-install 'ido-completing-read+))
  (require 'smex) 
  (smex-initialize)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; mappings
