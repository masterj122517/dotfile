(deftheme masterj "A custom theme based on Ghotty colors")

(let ((class '((class color) (min-colors 89)))
      (palette '("#4b565c" "#e67e80" "#a7c080" "#dbbc7f"
                 "#7fbbb3" "#d699b6" "#83c092" "#d3c6aa"
                 "#4b565c" "#ef989b" "#b5cba0" "#f2d5ae"
                 "#9ec3c4" "#e0a3c1" "#a7c6a2" "#f2e9de"))
      (bg "#2b3339")
      (fg "#d3c6aa")
      (cursor "#d3c6aa")
      (selection-bg "#4f5b58")
      (selection-fg "#f2e9de"))

  (custom-theme-set-faces
   'masterj

   ;; 基本界面
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(cursor ((,class (:background ,cursor))))
   `(region ((,class (:background ,selection-bg :foreground ,selection-fg))))
   `(highlight ((,class (:background ,selection-bg))))
   `(fringe ((,class (:background ,bg))))
   `(minibuffer-prompt ((,class (:foreground ,(nth 4 palette) :bold t))))
   `(vertical-border ((,class (:foreground ,(nth 0 palette)))))
   `(line-number ((,class (:foreground ,(nth 8 palette) :background ,bg))))
   `(line-number-current-line ((,class (:foreground ,(nth 15 palette) :background ,(nth 0 palette)))))

   ;; 语法高亮
   `(font-lock-builtin-face ((,class (:foreground ,(nth 4 palette)))))
   `(font-lock-comment-face ((,class (:foreground ,(nth 8 palette)))))
   `(font-lock-constant-face ((,class (:foreground ,(nth 5 palette)))))
   `(font-lock-function-name-face ((,class (:foreground ,(nth 2 palette)))))
   `(font-lock-keyword-face ((,class (:foreground ,(nth 1 palette)))))
   `(font-lock-string-face ((,class (:foreground ,(nth 3 palette)))))
   `(font-lock-type-face ((,class (:foreground ,(nth 6 palette)))))
   `(font-lock-variable-name-face ((,class (:foreground ,(nth 12 palette)))))
   `(font-lock-warning-face ((,class (:foreground ,(nth 9 palette) :weight bold))))

   ;; 模式行
   `(mode-line ((,class (:background ,(nth 0 palette) :foreground ,(nth 15 palette)))))
   `(mode-line-inactive ((,class (:background ,bg :foreground ,(nth 8 palette)))))

   ;; 搜索
   `(isearch ((,class (:background ,(nth 1 palette) :foreground ,(nth 15 palette)))))
   `(lazy-highlight ((,class (:background ,(nth 11 palette) :foreground ,(nth 0 palette)))))

   ;; 补全
   `(completions-common-part ((,class (:foreground ,(nth 4 palette)))))
   `(completions-first-difference ((,class (:foreground ,(nth 1 palette)))))

   ;; minibuffer
   `(match ((,class (:background ,(nth 14 palette) :foreground ,(nth 0 palette)))))
   ))

(provide-theme 'masterj)
