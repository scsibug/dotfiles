;; Settings relevant to initial startup

;; Don't display anything on startup
(defun do-nothing (interactive))
(defalias 'view-emacs-news 'do-nothing)
(defalias 'describe-gnu-project 'do-nothing)
(setq
 inhibit-startup-message t
 inhibit-splash-screen t
 )

(provide 'startup)
