(evil-define-key 'normal 'global
  (kbd "s") nil
  (kbd ";") ":"
  (kbd ",") "@q"

  )
(evil-define-key 'normal 'global (kbd "<backspace>") "\"_ciw")
(evil-define-key 'visual 'global (kbd "<backspace>") "\"_d")
;; 分屏
(evil-define-key 'normal 'global (kbd "sv") ":vsplit<CR>")
(evil-define-key 'normal 'global (kbd "sp") ":split<CR>")
(evil-define-key 'normal 'global (kbd "sc") ":close<CR>")
(evil-define-key 'normal 'global (kbd "so") ":only<CR>")
