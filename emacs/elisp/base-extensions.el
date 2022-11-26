;;; base-extensions.el --- Load and configure extensions.
;;; Commentary:
;;; Code:
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package fira-code-mode
  :ensure t
  :custom (fira-code-mode-disabled-ligatures '("[]" "x"))  ; ligatures you don't want
    :if (display-graphic-p)
    :hook prog-mode) ; mode to enable fira-code-mode in

;; jump to locations
(use-package avy
  :ensure t
  :defer 10
  :bind
  ("C-c SPC" . 'avy-goto-char-2))

;; Programming icons
(use-package all-the-icons
  :ensure t)

;; Syntax
(use-package flycheck
  :ensure t
  :defer 5
  :hook ('after-init . global-flycheck-mode))

;; Completion
(use-package company
  :ensure t
  :defer 5
  :hook ('after-init . 'global-company-mode))

;; Initial Dashboard
;; select a random quote.
(setq my-dashboard-quotes
      '(;; Tron
        "On the other side of the screen, it all looks so easy."
        "User requests are what computers are for!"
        "I still don't understand why you want to break into the system."
        "I shouldn't have written all of those tank programs."
        "How are you going to run the universe if you can't answer a few unsolvable problems, huh?"
        "Come on, you scuzzy data, be in there."
        "This code disk means freedom."
        "Look. This... is all a mistake. I'm just a compound interest program."
        ;; Erik Naggum
        "If you want to know why Lisp doesn't win around you, find a mirror."
        "A word says more than a thousand images."
        "Languages shape the way we think, or don't."
        "Enlightenment is probably antithetical to impatience."
        "Elegance is necessarily unnatural, only achieveable at great expense."
        "The currency in the developer community is enthusiasm."
        "They don't make poles long enough for me want to touch Microsoft products."
        "A little knowledge is a dangerous thing. I regret that this isn't fatal."
	;; @EmacsRocks
	"If you think paredit is not for you then you need to become the kind of person that paredit is for."
	))

(setq dashboard-banner-logo-title (nth (random (length my-dashboard-quotes)) my-dashboard-quotes))
(setq dashboard-center-content t)
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-set-navigator t)
(use-package dashboard
  :ensure t
  :config
  (progn
    (setq dashboard-items '((recents  . 8)
                        (bookmarks . 8)
                        (projects . 8)
                        (registers . 8)))
    (dashboard-setup-startup-hook)
    (dashboard-modify-heading-icons '((recents . "file-text")
                                      (bookmarks . "book")))))

(use-package yaml-mode
  :ensure t
  :defer 5)

(use-package exec-path-from-shell
  :ensure t
  :defer 20
  :config
  (when (memq window-system '(mac ns))
    (setq exec-path-from-shell-arguments '("-l"))
    (setq exec-path-from-shell-variables '("PATH" "GOPATH" "PYTHONPATH"))
    (exec-path-from-shell-initialize)))

;; gradually expand regions
(use-package expand-region
  :ensure t
  :defer 5
  :bind
  ("C-=" . er/expand-region))

;; bring in counsel, ivy, swiper (autocomplete/search)
(use-package counsel
  :ensure t
  :defer 3
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-m" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("C-x c k" . counsel-yank-pop)
  ("C-c k" . 'counsel-rg)
  ("C-x l" . 'counsel-locate))

;; ivy / projectile integration
;; (use-package counsel-projectile
;;   :bind
;;   ("C-x v" . counsel-projectile)
;;   ("C-x c p" . counsel-projectile-ag)
;;   :config
;;   (counsel-projectile-on))

(use-package swiper
  :ensure t
  :defer 3
  :bind
  ("C-s" . 'swiper-isearch))

(use-package ivy
  :ensure t
  :bind
  ("C-x C-r" . 'ivy-resume)
  ("C-x b" . 'ivy-switch-buffer)
  ("C-c v" . 'ivy-push-view)
  ("C-c V" . 'ivy-pop-view)
  :config
  ;; ivy everywhere.
  (ivy-mode 1)
  ;; show recent files when switching buffers
  (setq ivy-use-virtual-buffers t)
  ;; show current search result number
  (setq ivy-count-format "(%d/%d) ")
  ;; wrap-around search
  (setq ivy-wrap t))

;; Magit
(use-package magit
  :ensure t
  :defer 10
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

(use-package restclient
  :ensure t
  :defer 5)

<<<<<<< HEAD
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

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil)
  (org-tree-slide-breadcrumbs " > "))

(global-set-key (kbd "<f8>") 'org-tree-slide-mode)
(global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)

(require 'ox-publish)

(use-package org-cliplink
  :ensure t)

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

(use-package unfill)

(use-package ox-reveal)

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
      '(
	;; Bookmarks
	("k" "bookmark" entry
	 "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n"
	 :target (file+olp "bookmarks.org" ())
	 :empty-lines 1
	 )
	;; Fleeting notes
	("f" "fleeting" entry
         "** TODO ${title}\n%?"
         :target (file+olp "inbox.org" ("Inbox"))
         :immediate-finish t
	 :jump-to-captured t
	 :empty-lines 1
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
         "- Book Link: %^{Url}\n- Author(s): %^{Authors}\n- ISBN: =%^{ISBN}=\n- Published: [%^{Published}]\n\n* Summary\n\n%?* Notes\n\n* Quotes\n\n* References\n"
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
	("p" "project" plain
         "%?/Project Summary/\n\n* References\n"
         :if-new (file+head "projects/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@project:\n")
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

(use-package org-roam-ui)

(use-package org-bullets
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

(use-package page-break-lines)
||||||| 6bb4cf3
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

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

(require 'ox-publish)

(use-package org-cliplink
  :ensure t)

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
      '(
	;; Bookmarks
	("k" "bookmark" entry
	 "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n"
	 :target (file+olp "bookmarks.org" ())
	 :empty-lines 1
	 )
	;; Fleeting notes
	("f" "fleeting" entry
         "** TODO ${title}\n%?"
         :target (file+olp "inbox.org" ("Inbox"))
         :immediate-finish t
	 :jump-to-captured t
	 :empty-lines 1
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
         "- Book Link: %^{Url}\n- Author(s): %^{Authors}\n- ISBN: =%^{ISBN}=\n- Published: [%^{Published}]\n\n* Summary\n\n%?* Notes\n\n* Quotes\n\n* References\n"
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
	("p" "project" plain
         "%?/Project Summary/\n\n* References\n"
         :if-new (file+head "projects/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@project:\n")
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
=======
>>>>>>> dot-emacs-redo

(use-package projectile
  :config
  (setq projectile-known-projects-file
        (expand-file-name "projectile-bookmarks.eld" temp-dir))

  (setq projectile-completion-system 'ivy)
  (projectile-global-mode))

;; display ^L as horizontal rule
(use-package page-break-lines
  :ensure t
  :defer 2)

;; see https://github.com/Fuco1/smartparens
;; M-x sp-cheat-sheet
;;(use-package smartparens
;;  :ensure t)
;;(require 'smartparens-config)
;;(add-hook 'js-mode-hook #'smartparens-strict-mode)
;;(add-hook 'emacs-lisp-mode-hook #'smartparens-strict-mode)

;; help identify available commands
(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  :custom (which-key-idle-delay 1.2))

;; easily move between windows
(use-package windmove
  :ensure t
  :defer 2
  :bind
  ("C-x <up>" . windmove-up)
  ("C-x <down>" . windmove-down)
  ("C-x <left>" . windmove-left)
  ("C-x <right>" . windmove-right))

;; C-u to duplicate line or region
(use-package duplicate-thing
  :ensure t
  :defer 2
  :init
  (defun my-duplicate-thing ()
    "Duplicate thing at point without changing the mark."
    (interactive)
    (save-mark-and-excursion (duplicate-thing 1)))
  :bind (("C-c u" . my-duplicate-thing)
         ("C-c C-u" . my-duplicate-thing)))

;; ledger-cli
(use-package ledger-mode
  :ensure t
  :defer 2)

;;(use-package rainbow-delimiters
;;  :ensure t
;;  :defer 2
;;  :hook ((prog-mode . rainbow-delimiters-mode)))

(use-package recentf
  :ensure t
  :config
  (setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/private/cache/recentf"))
  (recentf-mode 1))

(use-package undo-tree
  :ensure t
  :config
  ;; Remember undo history
  (setq
   undo-tree-auto-save-history nil
   undo-tree-history-directory-alist `(("." . ,(concat temp-dir "/undo/"))))
  (global-undo-tree-mode 1))


(add-hook 'java-mode-hook (lambda () (setq c-basic-offset 2)))

(provide 'base-extensions)
;;; base-extensions.el ends here
