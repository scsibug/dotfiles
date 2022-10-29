;; Settings relevant to initial startup

;; Don't display anything on startup
(defun do-nothing (interactive))
(defalias 'view-emacs-news 'do-nothing)
(defalias 'describe-gnu-project 'do-nothing)
(setq
 inhibit-startup-message t
 inhibit-splash-screen t
 )

;; Disable toolbar & menubar & scrollbar
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (  fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Highlight matching parens
(show-paren-mode 1)

(provide 'startup)
