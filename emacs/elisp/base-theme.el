;; '(custom-enabled-themes '(deeper-blue))

;;(ignore-errors (set-frame-font "Menlo-14"))

;; Requires manually installing FiraCode-Regular-Symbol
;; see https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632
(when (display-graphic-p)
  (ignore-errors (set-frame-font "Fira Code-14")))

(when (display-graphic-p)
  (load-theme 'deeper-blue))

(provide 'base-theme)
