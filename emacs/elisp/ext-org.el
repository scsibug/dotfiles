(use-package org
  :ensure t
  :defer 4
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
        ("C-c n i" . org-roam-node-insert)
        ("C-c n o" . org-id-get-create)
        ("C-c n t" . org-roam-tag-add)
        ("C-c n a" . org-roam-alias-add)
        ("C-c n l" . org-roam-buffer-toggle)))

(use-package org-tree-slide
  :ensure t
  :custom
  (org-image-actual-width nil)
  (org-tree-slide-breadcrumbs " > ")
  (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
  (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle))

(set-face-attribute 'org-block-begin-line nil :foreground "#2a2a2a")
(set-face-attribute 'org-block-end-line nil :foreground "#2a2a2a")

;; org publishing
(require 'ox-publish)

;; copy-paste org links with title pages
(use-package org-cliplink
  :defer 2
  :ensure t)

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :defer 5
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

(use-package unfill)

;; Don't include default CSS
(setq org-html-head-include-default-style nil)

;; add last-modified time
;;(add-hook 'before-save-hook 'time-stamp)

;; Update files with last modifed date, when #+lastmod: is available
(setq time-stamp-active t
      time-stamp-start "#\\+lastmod:[ \t]*"
      time-stamp-end "$"
      time-stamp-format "%04Y-%02m-%02d")
(add-hook 'before-save-hook 'time-stamp nil)

;; convert buffer to html
(use-package htmlize
  :defer 5
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
  :defer 5
  :ensure t)

(use-package org-roam
  :defer 5
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
(setq org-roam-capture-templates
      '(
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
	("c" "concept" plain
         "%?/Concept Summary/\n\n* References\n"
         :if-new (file+head "concepts/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@concept:\n")
         :immediate-finish t
         :unnarrowed t)
	("A" "area" plain
         "%?/Area Summary/\n\n* References\n"
         :if-new (file+head "area/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@area:\n")
         :immediate-finish t
         :unnarrowed t)

	("p" "project" plain
         "%?/Project Summary/\n\n* References\n"
         :if-new (file+head "projects/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@project:\n")
         :immediate-finish t
         :unnarrowed t)
	("m" "meeting" plain
         "%?\n* Attendees\n\n* Notes\n"
         :if-new (file+head "meetings/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@meeting:\n")
         :immediate-finish t
         :unnarrowed t)
	("n" "note" plain
	 "%?"
         :if-new (file+head "notes/%<%Y%m%d>-${slug}.org"
			    "#+lastmod: Time-stamp: <>\n#+title: ${title}\n#+category: ${title}\n#+date: %u\n#+filetags: :@note:\n")
         :immediate-finish t
         :unnarrowed t)))

(use-package org-bullets
  :ensure t
  :defer 6
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

(use-package org-roam-ui)

(use-package org-bullets
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

;(use-package org-projectile
;  :config
;  (org-projectile-per-project)
;  (setq org-projectile-per-project-filepath "todo.org"
;      org-agenda-files (append org-agenda-files (org-projectile-todo-files))))

(provide 'ext-org)
