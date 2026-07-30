;; Force .scm files to use scheme-mode
(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))

(use-package geiser-guile
  :ensure)

(use-package paredit
  :ensure)
;; Remove sh from interpreter-mode-alist if needed
;; (This is more aggressive and may affect other files)
;; (setq interpreter-mode-alist
;;       (assq-delete-all "sh" interpreter-mode-alist))

(add-to-list 'interpreter-mode-alist '("guile" . scheme-mode))

;; Enable minor modes
(add-hook 'scheme-mode-hook #'paredit-mode)
(add-hook 'scheme-mode-hook #'geiser-mode)

(provide 'lang-scheme)
