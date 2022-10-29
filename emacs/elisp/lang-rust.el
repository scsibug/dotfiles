(use-package rustic
  :config
  (setq
   rustic-lsp-client 'eglot
   rustic-format-on-save t
   eglot-send-changes-idle-time (* 60 60)
   ;; Disable the annoying doc popups in the minibuffer.
   )
  (add-hook 'eglot-managed-mode-hook (lambda () (eldoc-mode -1)))
  )

(provide 'lang-rust)
