;; '(custom-enabled-themes '(deeper-blue))
(ignore-errors (set-frame-font "Menlo-14"))

(when (display-graphic-p)
  (load-theme 'deeper-blue))

(provide 'base-theme)
