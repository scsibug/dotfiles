;; '(custom-enabled-themes '(deeper-blue))

;;(ignore-errors (set-frame-font "Menlo-14"))

;; Requires manually installing FiraCode-Regular-Symbol
;; see https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632
(ignore-errors (set-frame-font "Fira Code-16"))

(when (display-graphic-p)
  (load-theme 'deeper-blue))

(provide 'base-theme)
