(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("[]" "x"))  ; ligatures you don't want
    :if (display-graphic-p)
    :hook prog-mode) ; mode to enable fira-code-mode in

(use-package avy
  :bind
  ("C-c SPC" . avy-goto-char-2))

;; Programming icons
(use-package all-the-icons)
(provide 'base-extensions)
