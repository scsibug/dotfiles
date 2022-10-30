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
  :defer 5
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
  :defer 5
  :hook ('after-init . 'global-company-mode))

;; Initial Dashboard
;; select a random (tron) quote.
(setq my-dashboard-quotes
      '("On the other side of the screen, it all looks so easy."
	"User requests are what computers are for!"
	"I still don't understand why you want to break into the system."
	"I shouldn't have written all of those tank programs."
	"How are you going to run the universe if you can't answer a few unsolvable problems, huh?"
	"Come on, you scuzzy data, be in there."
	"This code disk means freedom."
	"Look. This... is all a mistake. I'm just a compound interest program."))

(setq dashboard-banner-logo-title (nth (random (length my-dashboard-quotes)) my-dashboard-quotes))
(setq dashboard-center-content t)
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-set-navigator t)
(use-package dashboard
  :ensure t
  :config
  (progn
    (dashboard-setup-startup-hook)
    (dashboard-modify-heading-icons '((recents . "file-text")
				      (bookmarks . "book")))
    )
  )

(provide 'base-extensions)
;;; base-extensions.el ends here
