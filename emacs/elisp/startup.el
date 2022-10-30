;; Settings relevant to initial startup

;; prioritize displaying the screen before handling events
(setq redisplay-dont-pause t)

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

;; Higher GC threshold, only run on idle/focus-change
;; https://www.bytedude.com/improving-emacs-performance/
(add-hook 'after-init-hook
          #'(lambda ()
              (setq gc-cons-threshold (* 100 1000 1000))))
(add-hook 'focus-out-hook 'garbage-collect)
(run-with-idle-timer 5 t 'garbage-collect)

(provide 'startup)
