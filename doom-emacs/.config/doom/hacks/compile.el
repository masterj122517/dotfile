;;; hacks/compile.el -*- lexical-binding: t; -*-

(defun my/compile-run ()
  "根据当前 buffer 文件类型自动编译运行。"
  (interactive)
  (save-buffer)
  (let* ((filetype major-mode)
         (filename (buffer-file-name))
         (filedir (file-name-directory filename))
         (project-root (or (projectile-project-root) filedir))
         (default-directory project-root)
         (compile-cmd nil))
    (cond
     ;; C/C++
     ((or (eq filetype 'c-mode) (eq filetype 'c++-mode))
      (if (file-exists-p (concat project-root "Makefile"))
          (setq compile-cmd "make")
        (setq compile-cmd
              (format "gcc %s -o %s && ./%s && rm %s"
                      (shell-quote-argument filename)
                      (file-name-sans-extension (file-name-nondirectory filename))
                      (file-name-sans-extension (file-name-nondirectory filename))
                      (file-name-sans-extension (file-name-nondirectory filename)))))
      )
     ;; Python
     ((eq filetype 'python-mode)
      (setq compile-cmd (format "python3 %s" (shell-quote-argument filename))))
     ;; Rust
     ((eq filetype 'rust-mode)
      (setq compile-cmd "cargo run"))
     ;; JavaScript (node)
     ((eq filetype 'js-mode)
      (setq compile-cmd (format "node %s" (shell-quote-argument filename))))
     ;; Lua
     ((eq filetype 'lua-mode)
      (setq compile-cmd (format "luajit %s" (shell-quote-argument filename))))
     ;; Go
     ((eq filetype 'go-mode)
      (setq compile-cmd (format "go run %s" (shell-quote-argument filename))))
     ;; Java
     ((eq filetype 'java-mode)
      (setq compile-cmd
            (format "javac %s && java %s && rm %s.class"
                    (shell-quote-argument filename)
                    (file-name-sans-extension (file-name-nondirectory filename))
                    (file-name-sans-extension (file-name-nondirectory filename)))))
     (t (message "ERROR: We Don't support this filetype!!!")))
    (when compile-cmd
      (compile compile-cmd))))
