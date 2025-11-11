;; Settings relevant to initial startup

;; prioritize displaying the screen before handling events
;;; Code:

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

(define-minor-mode prot/display-line-number-mode
  "Disable line numbers, except for programming modes"
  :init-value nil
  :global nil
  (if prot/display-line-number-mode
      (unless (derived-mode-p 'prog-mode)
	(display-line-numbers-mode -1))
    (display-line-numbers-mode 1)))

(provide 'startup)
