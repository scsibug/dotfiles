(use-package rustic
  :config
  (setq
   rustic-lsp-client 'eglot
   eglot-send-changes-idle-time (* 60 60)
   ;; Disable the annoying doc popups in the minibuffer.
   )
  (add-hook 'eglot-managed-mode-hook (lambda () (eldoc-mode -1)))
  )

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

(provide 'lang-rust)
