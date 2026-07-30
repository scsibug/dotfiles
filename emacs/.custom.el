(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ignored-local-variable-values
   '((eval progn (add-to-list 'load-path (concat (vc-root-dir) "emacs"))
           (require 'google-c-style) (google-set-c-style)
           (google-make-newline-indent))))
 '(indent-tabs-mode nil)
 '(ledger-binary-path "/Users/scsibug/.nix-profile/bin/ledger")
 '(package-selected-packages
   '(all-the-icons all-the-icons-dired avy cargo command-log-mode company
                   counsel counsel-projectile dashboard diminish
                   dimmer doom-themes dumb-jump duplicate-thing
                   exec-path-from-shell expand-region fira-code-mode
                   flycheck flycheck-pest flycheck-rust flymake-pest
                   geiser-guile hlinum htmlize keyfreq ledger-cli
                   ledger-mode lsp-ivy lsp-mode lsp-treemacs lsp-ui
                   magit magit-popup multiple-cursors neotree
                   org-bullets org-cliplink org-projectile org-roam
                   org-roam-ui org-tree-slide ox ox-hugo ox-reveal
                   page-break-lines paredit parinfer-rust-mode
                   pest-mode projectile racer rainbow-delimiters
                   restclient rustic simple-httpd smartparens smex
                   solarized-theme toc-org tomelr toml-mode undo-tree
                   unfill use-package wgrep which-key yaml-mode
                   yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bold ((t (:background "black" :foreground "white smoke" :weight bold))))
 '(markdown-code-face ((t (:inherit default))))
 '(org-level-1 ((t (:extend nil :foreground "DodgerBlue1" :height 1.2))))
 '(org-level-2 ((t (:extend nil :foreground "medium spring green" :height 1.1))))
 '(org-level-3 ((t (:extend nil :foreground "dark orange" :height 1.05))))
 '(org-level-4 ((t (:extend nil :foreground "gold")))))
