;;; base-extensions.el --- Load and configure extensions.
;;; Commentary:
;;; Code:

(use-package yasnippet)

;; this does not /install/ the fonts.  Run M-x all-the-icons-install-fonts for that.
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
        ;; @EmacsRocks (https://x.com/emacsrocks)
        "If you think paredit is not for you then you need to become the kind of person that paredit is for."
        ;; Systemantics
        "Systems in general work poorly or not at all."
        "A simple system may or may not work."
        "Some complex systems actually work."
        "If a system is working, leave it alone."
        "Programs never run the first time.  Complex programs never run."
        "Generalized Uncertainty Principle: Systems Display Antics."
        "Systems should not be unnecessarily multiplied."
        "The Fundamental Theorem: New systems generate new problems."
        "The Operational Fallacy: The system itself does not do what it says it is doing."
        "Le Chatelier's Principle: Complex systems tend to oppose their own proper function."
        "The system always kicks back."
        "Fundamental Failure Mode Theorem: Complex systems usually operate in failure mode."
        "The crucial variables are discovered by accident."
        "In setting up a new system, tread softly.  You may be disturbing another system that is actually working."
	;; George Harrison / Beatles
	"The problems you sow are the troubles you're reaping"
	;; Leslie Lamport
	"If you're thinking without writing, you only think you're thinking."
	;; Neil Gaiman, The Sandman, Vol 3
	"The price of getting what you want, is getting what you once wanted."
        ))

(setq dashboard-banner-logo-title
      (nth (random (length my-dashboard-quotes)) my-dashboard-quotes))
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

(define-key ivy-minibuffer-map (kbd "C-j") 'ivy-immediate-done)
(define-key ivy-minibuffer-map (kbd "C-m") 'ivy-alt-done)


(add-to-list 'exec-path "/Users/scsibug/.nix-profile/bin")

;; Magit
(use-package magit
  :ensure t
  :defer 10
  :config
  :bind
  ("C-x g s" . magit-status)
  ("C-x g x" . magit-checkout)
  ("C-x g c" . magit-commit)
  ("C-x g p" . magit-push)
  ("C-x g u" . magit-pull)
  ("C-x g e" . magit-ediff-resolve)
  ("C-x g r" . magit-rebase-interactive))
(setq magit-completing-read-function 'ivy-completing-read)

(use-package restclient
  :ensure t
  :defer 5)

(use-package projectile
  :config
  (setq projectile-known-projects-file
	(expand-file-name "projectile-bookmarks.eld" temp-dir))
  (setq projectile-completion-system 'ivy)
  (projectile-global-mode))

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
