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
    (dashboard-setup-startup-hook)
    (dashboard-modify-heading-icons '((recents . "file-text")
                                      (bookmarks . "book")))))



(use-package yaml-mode
  :ensure t
  :defer 5)

;; copy environment variables to shell on OS X
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

(provide 'base-extensions)
;;; base-extensions.el ends here
