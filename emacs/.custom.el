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
   '(flymake-pest flycheck-pest pest-mode yasnippet projectile rustic restclient yaml-mode ox-reveal unfill org-roam-ui org-tree-slide org-cliplink htmlize simple-httpd toml-mode tomelr ox ox-hugo org-roam toc-org fira-code-mode page-break-lines counsel flycheck parinfer-rust-mode dimmer diminish duplicate-thing all-the-icons-dired all-the-icons doom-themes rainbow-delimiters ledger-mode ledger-cli lsp-treemacs lsp-ivy lsp-ui lsp-mode which-key wgrep use-package undo-tree solarized-theme smex smartparens racer org-projectile org-bullets neotree multiple-cursors magit-popup magit hlinum flycheck-rust expand-region exec-path-from-shell dumb-jump dashboard counsel-projectile company cargo avy)))
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
