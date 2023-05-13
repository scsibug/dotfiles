(use-package rustic
  :config
  (setq
   rustic-lsp-client 'lsp-mode
   rustic-format-on-save t
   )
  )

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

;; https://robert.kra.hn/posts/rust-emacs-setup/#lsp-mode-and-lsp-ui-mode
(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.2)
  ;; enable / disable the hints as you prefer:
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  :config
 (add-hook 'lsp-mode-hook 'lsp-ui-mode))

 (use-package lsp-ui
   :ensure
   :commands lsp-ui-mode
   :custom
   (lsp-ui-peek-always-show t)
   ;; Bad wrapping with sideline when you don't set this.
   (lsp-ui-sideline-show-hover t)
   (lsp-ui-doc-enable nil))

(custom-set-faces '(markdown-code-face ((t (:inherit default)))))

(provide 'lang-rust)
