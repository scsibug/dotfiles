;;(toggle-debug-on-error)

(when (display-graphic-p)
  (use-package fira-code-mode
    :custom (fira-code-mode-disabled-ligatures '("[]" "x"))  ; ligatures you don't want
    :hook prog-mode)                                         ; mode to enable fira-code-mode in
  )
(use-package avy
  :bind
  ("C-c SPC" . avy-goto-char))

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq-default ediff-highlight-all-diffs 'nil)
  (setq ediff-diff-options "-w"))

(use-package exec-path-from-shell
  :config
  ;; Add GOPATH to shell
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-copy-env "GOPATH")
    (exec-path-from-shell-copy-env "PYTHONPATH")
    (exec-path-from-shell-initialize)))

;; Nice Lisp editing
(use-package parinfer-rust-mode
    :hook emacs-lisp-mode
    :init
    (setq parinfer-rust-auto-download t))

(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

(use-package flycheck)


(use-package counsel
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-m" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("C-x c k" . counsel-yank-pop))

(use-package counsel-projectile
  :bind
  ("C-x v" . counsel-projectile)
  ("C-x c p" . counsel-projectile-ag)
  :config
  (counsel-projectile-on))

(use-package ivy
  :bind
  ("C-x s" . swiper)
  ("C-x C-r" . ivy-resume)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers nil)
  (define-key read-expression-map (kbd "C-r") 'counsel-expression-history))

(use-package magit
  :config

  (setq magit-completing-read-function 'ivy-completing-read)

  :bind
  ;; Magic
  ("C-x g s" . magit-status)
  ("C-x g x" . magit-checkout)
  ("C-x g c" . magit-commit)
  ("C-x g p" . magit-push)
  ("C-x g u" . magit-pull)
  ("C-x g e" . magit-ediff-resolve)
  ("C-x g r" . magit-rebase-interactive))

(use-package magit-popup)

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C->" . mc/mark-all-like-this))

(use-package neotree
  :config
  (setq neo-theme 'arrow
        neotree-smart-optn t
        neo-window-fixed-size nil)
  ;; Disable linum for neotree
  (add-hook 'neo-after-create-hook 'disable-neotree-hook))

(use-package org
  :config
  (setq org-directory "~/repos/org-roam"
        org-default-notes-file (concat org-directory "/todo.org")
	org-html-doctype "html5"
	org-use-tag-inheritance t
	org-agenda-files (directory-files-recursively "~/repos/org-roam/" "\\.org$"))
  (setq org-todo-keywords
	'((sequence "TODO" "WAITING" "|" "DONE")))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c n f" . org-roam-node-find)
  (:map org-mode-map
        (("C-c n i" . org-roam-node-insert)
         ("C-c n o" . org-id-get-create)
         ("C-c n t" . org-roam-tag-add)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n l" . org-roam-buffer-toggle))))



(require 'ox-publish)

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)


;; Don't include default CSS
(setq org-html-head-include-default-style nil)
;(setq org-html-head-include-scripts nil)

;; add last-modified time
;;(add-hook 'before-save-hook 'time-stamp)

  ;; Update files with last modifed date, when #+lastmod: is available
(setq time-stamp-active t
      time-stamp-start "#\\+lastmod:[ \t]*"
      time-stamp-end "$"
      time-stamp-format "%04Y-%02m-%02d")
(add-hook 'before-save-hook 'time-stamp nil)

(use-package htmlize
  :ensure t)

;; Use simpleCSS by default
(setq org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")


(setq org-publish-project-alist
      '(("roam-notes"
         :base-directory "~/repos/org-roam/"
         :base-extension "org"
	 :recursive t
	 :auto-sitemap t
	 :sitemap-filename "sitemap.org"
	 :sitemap-title "Sitemap"
         :publishing-directory "~/org-publish/"
         :publishing-function org-html-publish-to-html
         :exclude "PrivatePage.org" ;; regexp
         :headline-levels 3
         :section-numbers nil
	 :html-validation-link nil
         :with-toc nil
	 :with-author nil
	 :with-creator t
	 :time-stamp-file nil
         :html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />
                     <link rel=\"stylesheet\" href=\"/css/style.css\" type=\"text/css\"/>"
         :html-preamble t)
	("roam-static"
	 :base-directory "~/repos/org-roam/"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :publishing-directory "~/org-publish/"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )
	("roam" :components ("roam-notes" "roam-static"))))

(use-package simple-httpd
  :ensure t)

(use-package org-roam
    :ensure t)
(setq org-roam-directory (file-truename "~/repos/org-roam"))
(setq org-return-follows-link  t)
(setq org-adapt-indentation nil)
(org-roam-db-autosync-mode)

(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-side-window)
               (side . right)
               (slot . 0)
               (window-width . 0.33)
               (window-parameters . ((no-other-window . t)
                                     (no-delete-other-windows . t)))))


; filetags don't work, because they apply to headings, not files.

(setq org-roam-capture-templates
      ;; Fleeting notes
      '(("f" "fleeting" plain
         "%?"
         :if-new (file+olp "inbox.org"
                            "* ${title}\n\n")
         :immediate-finish t
         :unnarrowed t)
      ;; Articles should have a link via ROAM_REF
      ("a" "article" plain
         "- [[%^{Url}][${title}]]\n- Author(s): %^{Authors}\n- Published:%^{Published}\n\n* Summary\n%?\n* Notes\n\n* Quotes\n\n* References\n"
         :if-new (file+head "articles/%<%Y%m%d>-${slug}.org"
                            "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@article:\n")
         :immediate-finish t
         :unnarrowed t)
	("t" "talk" plain
         "- [[%^{Url}][${title}]]\n- Speaker(s): %^{Speakers}\n- Length (min):%^{Length (min)}\n- Published: %^{Published}\n\n* Summary\n\n*Notes\n\n*Quotes\n\n*References\n"
         :if-new (file+head "talks/%<%Y%m%d>-${slug}.org"
                            "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@talk:\n")
         :immediate-finish t
         :unnarrowed t)
	("b" "book" plain
         "#+title: ${title}\n#+category: ${title}\n#+filetags: :book:\n#+date: %u\n\n- Book Link: %?\n- Author(s):\n- ISBN:\n- Published:\n\n* Summary\n\n*Notes\n\n*Quotes\n\n*References\n"
         :if-new (file+head "books/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@book:\n")
         :immediate-finish t
         :unnarrowed t)
	("s" "software" plain
	 "- Homepage: %^{Project Homepage}\n\n*Summary\n\n%?\n*Configuration Notes\n\n"
         :if-new (file+head "software/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@software:\n")
         :immediate-finish t
         :unnarrowed t)
	("h" "hardware" plain
	 "#+title: ${title}\n#+category: ${title}\n#+filetags: :hardware:\n#+date: %u\n\n- Homepage: %?\n- Manufacturer:\n- Model:\n"

         :if-new (file+head "hardware/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@software:\n")
         :immediate-finish t
         :unnarrowed t)
	("c" "concept" plain
         "%?/Concept Summary/\n\n* References\n"
         :if-new (file+head "concepts/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@concept:\n")
         :immediate-finish t
         :unnarrowed t)
	("n" "note" plain
	 "%?"
         :if-new (file+head "notes/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@note:\n")
         :immediate-finish t
         :unnarrowed t)))

;(use-package org-projectile
;  :config
;  (org-projectile-per-project)
;  (setq org-projectile-per-project-filepath "todo.org"
;	org-agenda-files (append org-agenda-files (org-projectile-todo-files))))

(use-package org-bullets
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

(use-package page-break-lines)

(use-package projectile
  :config
  (setq projectile-known-projects-file
        (expand-file-name "projectile-bookmarks.eld" temp-dir))

  (setq projectile-completion-system 'ivy)

  (projectile-global-mode))

(use-package recentf
  :config
  (setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/private/cache/recentf"))
  (recentf-mode 1))

(use-package smartparens)

(use-package smex)

(use-package undo-tree
  :config
  ;; Remember undo history
  (setq
   undo-tree-auto-save-history nil
   undo-tree-history-directory-alist `(("." . ,(concat temp-dir "/undo/"))))
  (global-undo-tree-mode 1))

;; help identify available commands
(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  :custom (which-key-idle-delay 1.2))

(use-package which-key
  :custom
  (which-key-setup-side-window-bottom)
  (which-key-enable-extended-define-key t)
  :config
  (which-key-setup-minibuffer))

(use-package windmove
  :bind
  ("C-x <up>" . windmove-up)
  ("C-x <down>" . windmove-down)
  ("C-x <left>" . windmove-left)
  ("C-x <right>" . windmove-right))

(use-package wgrep)

;(use-package yasnippet
;  :config
;  (yas-global-mode 1))

(use-package dumb-jump
  :config
    (dumb-jump-mode))

(use-package duplicate-thing
  :init
  (defun my-duplicate-thing ()
    "Duplicate thing at point without changing the mark."
    (interactive)
    (save-mark-and-excursion (duplicate-thing 1)))
  :bind (("C-c u" . my-duplicate-thing)
         ("C-c C-u" . my-duplicate-thing)))

(use-package neuron-mode)

(use-package ledger-mode)

(use-package haskell-mode)

(use-package tidal)
(setq tidal-interpreter "/Users/scsibug/.ghcup/bin/ghci")
(setq tidal-boot-script-path "~/.cabal/store/ghc-8.10.4/tdl-1.7.4-ee4f92ea/share/BootTidal.hs")

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

;(use-package all-the-icons)

;(use-package all-the-icons-dired
;  :after all-the-icons
;  :hook (dired-mode . all-the-icons-dired-mode))

(provide 'base-extensions)
