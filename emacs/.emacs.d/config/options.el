;; 显示行号
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; 当前行高亮
;(global-hl-line-mode 1)
;; 禁用 Emacs GUI 元素（工具栏/菜单栏/滚动条）
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)       ;; 禁用启动画面

;; 关闭启动屏幕
(setq inhibit-startup-screen t)

(setq-default indent-tabs-mode nil)   ;; 禁止使用 Tab 字符
(setq-default tab-width 4)            ;; 设置 Tab 键为 4 个空格
(setq-default standard-indent 4)      ;; 确保缩进宽度为 4 空格
;; 启用自动缩进
(electric-indent-mode 1)
;; 在按 Tab 键时插入 4 个空格（当在正常模式下时）
(global-set-key (kbd "TAB") 'self-insert-command)
(setq select-enable-clipboard t)      ;; 启用剪贴板
(setq scroll-margin 8)                ;; 设置滚动边距
(setq make-backup-files nil)          ;; 禁用备份文件
(setq auto-save-default nil)          ;; 禁用自动保存
;; set font
(set-face-attribute 'default nil :family "Comic Code" :height 190)
