;;; init.el --- A small, single-file Emacs config  -*- lexical-binding: t; -*-

;;; Note: Add a trampoline to add emacs.app to OS X Dock:
;;nix run github:hraban/mac-app-util -- mktrampoline \
;;  ~/.nix-profile/Applications/Emacs.app ~/Applications/Emacs.app

;; Stop Customize from writing its junk into this file.
;; A throwaway temp file keeps everything in ONE file.
(setq custom-file (make-temp-file "emacs-custom-"))

;; block native compilation of this org function.  Used to fix the
;; error "Invalid function: org-element-with-disabled-cache"
(setq native-comp-jit-compilation-deny-list '(".*org-element.*"))

;;;;;;;;;;;;;;;;;;;; State Management

;;; State files -> $XDG_STATE_HOME/emacs (default ~/.local/state/emacs)
(defvar my/state-dir
  (expand-file-name "emacs/" (or (getenv "XDG_STATE_HOME") "~/.local/state"))
  "Where Emacs keeps per-machine state that isn't configuration.")
(make-directory my/state-dir t)

(defun my/state-file (name)
  "Return NAME expanded inside `my/state-dir'."
  (expand-file-name name my/state-dir))

;;; Packages -> $XDG_DATA_HOME/emacs/elpa (default ~/.local/share/emacs/elpa)
(defvar my/data-dir
  (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME") "~/.local/share"))
  "Where Emacs keeps per-user data that isn't configuration.")

(setq package-user-dir       (expand-file-name "elpa/" my/data-dir)
      package-gnupghome-dir  (expand-file-name "gnupg/" package-user-dir))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-activate-all)   ; make packages from the new location available


(setopt auto-save-list-file-prefix (my/state-file "auto-save-list/.saves-")
      backup-directory-alist     `(("." . ,(my/state-file "backups/")))
      savehist-file              (my/state-file "history")
      recentf-save-file          (my/state-file "recentf")
      save-place-file            (my/state-file "places")
      project-list-file          (my/state-file "projects")
      transient-history-file     (my/state-file "transient/history.el"))

;; setup a private directory
(defconst private-dir (expand-file-name "private"
					my/data-dir))
;; setup a temp cache directory
(defconst temp-dir (format "%s/cache" private-dir)
  "Elisp temp directories.")


(setq auto-save-file-name-transforms
      `((".*" ,(my/state-file "auto-saves/") t)))
(make-directory (my/state-file "auto-saves/") t)

;;;;;;;;;;;;;;;;;;;; Package Setup

(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/"))

;; install use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;;
(require 'use-package)

;;;;;;;;;;;;;;;;;;;; Basic UI
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
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(bold ((t (:background "black" :foreground "white smoke" :weight bold))))
 '(markdown-code-face ((t (:inherit default))))

 '(org-level-1 ((t (:extend nil :foreground "#4444cc" :height 1.2))))
 '(org-level-2 ((t (:extend nil :foreground "#3333bb" :height 1.1))))
 '(org-level-3 ((t (:extend nil :foreground "#2222aa" :height 1.05))))
 '(org-level-4 ((t (:extend nil :foreground "#111199" :height 1.0)))))

;; Show column numbers in the mode line
(column-number-mode)

;; Show line numbers on left-hand side
(global-display-line-numbers-mode)

;;;;;;;;;;;;;;;;;;;; Startup

;; Don't display anything on startup
(defun do-nothing (interactive))
(defalias 'view-emacs-news 'do-nothing)
(defalias 'describe-gnu-project 'do-nothing)
(setq
 inhibit-startup-message t
 inhibit-splash-screen t
 )

;; Disable toolbar & menubar & scrollbar
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (  fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(define-minor-mode prot/display-line-number-mode
  "Disable line numbers, except for programming modes"
  :init-value nil
  :global nil
  (if prot/display-line-number-mode
      (unless (derived-mode-p 'prog-mode)
        (display-line-numbers-mode -1))
    (display-line-numbers-mode 1)))

;;;;;;;;;;;;;;;;;;;; Base

;; Use UTF-8
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)
(set-terminal-coding-system  'utf-8)
(set-keyboard-coding-system  'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system        'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))


(setq confirm-kill-emacs                  nil
      confirm-nonexistent-file-or-buffer  t
      save-interprogram-paste-before-kill t
      mouse-yank-at-point                 t
      require-final-newline               t
      visible-bell                        nil
      ring-bell-function                  'ignore
      ;; http://xahlee.info/emacs/emacs/emacs_stop_cursor_enter_prompt.html
      minibuffer-prompt-properties
      '(read-only t point-entered minibuffer-avoid-prompt cursor-intangible t face minibuffer-prompt)
      ;; Disable non selected window highlight
      cursor-in-non-selected-windows     nil
      highlight-nonselected-windows      nil
      ;; PATH
      exec-path                          (append exec-path '("/usr/local/bin/"))
      ;; do not insert tabs on indentation
      indent-tabs-mode                   nil
      fringes-outside-margins            t
      x-select-enable-clipboard          t
      use-package-always-ensure          t
      ;;initial-scratch-message nil
      ;; Never ding at me, ever.
      ring-bell-function 'ignore
      ;; Prompts should go in the minibuffer, not in a GUI.
      use-dialog-box nil
      ;; Fix undo in commands affecting the mark.
      mark-even-if-inactive nil
      ;; Let C-k delete the whole line.
      kill-whole-line t
      )

;;;;;;;;;;;;;;;;;;;; Theme

;;(when (display-graphic-p)
;;  (ignore-errors (set-frame-font "Fira Code-14")))

(setq modus-operandi-tinted-palette-overrides
      '((bg-main "#FFF7E9")
        (fringe "#F0F0E0")))

(when (display-graphic-p)
  (load-theme 'modus-operandi-tinted :no-confirm))

;;;;;;;;;;;;;;;;;;;; Extensions

(setq package-install-upgrade-built-in t)
;; fix an issue with magit needing a newer version of transient:
(use-package transient :ensure t)
(progn (unload-feature 'transient t) (require 'transient))

;; use tree sitter markdown mode
(use-package markdown-ts-mode
  :ensure nil
  :mode ("\\.md\\'" "\\.mdx\\'" "\\.markdown\\'")
  :config
  (require 'markdown-ts-mode-x))

;; this does not /install/ the fonts.  Run M-x all-the-icons-install-fonts for that.
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

;; jump to locations
;; (use-package avy
;;   :ensure t
;;   :bind
;;   ("C-c SPC" . 'avy-goto-char-2))

;; display ^L as horizontal rule
(use-package page-break-lines
  :ensure t)

;; ledger-cli
(use-package ledger-mode
  :ensure t)


;;;;;;;;;;;;;;;;;;;; Java
(add-hook 'java-mode-hook (lambda () (setq c-basic-offset 2)))
;;;;;;;;;;;;;;;;;;;; Functions

;; Syntax
(use-package flycheck
  :ensure t
  :hook ('after-init . global-flycheck-mode))

;; ;; Completion
(use-package company
  :ensure t
  :hook ('after-init . 'global-company-mode))

;;;;;;;;;;;;;;;;;;;; Dashboard

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
        ;; Charles Spurgeon
        "By perseverance the snail reached the ark"
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

;;;;;;;;;;;;;;;;;;;; Global Keys

;;;;;;;;;;;;;;;;;;;; Org Mode

(use-package org
  :ensure t
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


;;(set-face-attribute 'org-block-begin-line nil :foreground "#2a2a2a")
;;(set-face-attribute 'org-block-end-line nil :foreground "#2a2a2a")

;; Update files with last modifed date, when #+lastmod: is available
(setq time-stamp-active t
      time-stamp-start "#\\+lastmod:[ \t]*"
      time-stamp-end "$"
      time-stamp-format "%04Y-%02m-%02d")
(add-hook 'before-save-hook 'time-stamp nil)

;; Don't include default CSS
(setq org-html-head-include-default-style nil)


;; Use simpleCSS by default
(setq org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")


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
  :config
  (setq org-hide-leading-stars t)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-bullets-mode t))))

(setq org-priority-highest 0
      org-priority-lowest 5
      org-priority-start-cycle-with-default t)

(org-babel-do-load-languages 'org-babel-load-languages '((python . t)))
(setq org-confirm-babel-evaluate nil)
;;;;;;;;;;;;;;;;;;;; Rust

(setq exec-path (append exec-path '("~/.cargo/bin")))

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
  (lsp-eldoc-render-all nil)
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
   (lsp-ui-doc-enable t))


;; rust lsp code annotations need this, otherwise lines may shift in height
(custom-set-faces '(markdown-code-face ((t (:inherit default)))))

;;;;;;;;;;;;;;;;;;;; Scheme

;;;;;;;;;;;;;;;;;;;; Counsel, Ivy, Swiper

(use-package counsel
  :ensure t
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-m" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("C-x c k" . counsel-yank-pop)
  ("C-c k" . 'counsel-rg)
  ("C-x l" . 'counsel-locate))

(use-package swiper
  :ensure t
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

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after (ivy counsel)
  :config
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line) ; recommended
  (ivy-rich-mode 1))

(define-key ivy-minibuffer-map (kbd "C-j") 'ivy-immediate-done)
(define-key ivy-minibuffer-map (kbd "C-m") 'ivy-alt-done)

;;;;;;;;;;;;;;;;;;;; Projectile

(use-package projectile
  :config
  (setq projectile-known-projects-file  (my/state-file "projectile-bookmarks.eld"))
  (setq projectile-completion-system 'ivy)
  (projectile-mode))

;;;;;;;;;;;;;;;;;;;; Vertico, Orderless, Marginalia, Consult and Embark
;;;; Built-in tweaks that help minibuffer completion
;; (use-package emacs
;;   :ensure nil
;;   :custom
;;   (enable-recursive-minibuffers t)
;;   ;; Hide M-x commands that don't apply to the current mode
;;   (read-extended-command-predicate #'command-completion-default-include-p)
;;   ;; Keep the cursor out of the minibuffer prompt
;;   (minibuffer-prompt-properties
;;    '(read-only t cursor-intangible t face minibuffer-prompt))
;;   :hook (minibuffer-setup . cursor-intangible-mode))

;; ;; Save minibuffer history across sessions (Vertico sorts by it)
;; (use-package savehist
;;   :ensure nil
;;   :init (savehist-mode))

;; ;;;; Vertico: vertical completion UI
;; (use-package vertico
;;   :init (vertico-mode)
;;   :custom
;;   (vertico-cycle t)      ; wrap around at top/bottom
;;   (vertico-count 15))

;; ;; Vertico extension: smarter file-path navigation
;; (use-package vertico-directory
;;   :ensure nil            ; ships with vertico
;;   :after vertico
;;   :bind (:map vertico-map
;;               ("RET"   . vertico-directory-enter)
;;               ("DEL"   . vertico-directory-delete-char)
;;               ("M-DEL" . vertico-directory-delete-word))
;;   :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; ;;;; Orderless: space-separated, any-order matching
;; (use-package orderless
;;   :custom
;;   (completion-styles '(orderless basic))
;;   (completion-category-defaults nil)
;;   (completion-category-overrides '((file (styles partial-completion)))))

;; ;;;; Marginalia: annotations in the minibuffer
;; (use-package marginalia
;;   :bind (:map minibuffer-local-map
;;               ("M-A" . marginalia-cycle))
;;   :init (marginalia-mode))

;; ;;;; Consult: enhanced search/navigation commands
;; (use-package consult
;;   :bind (;; C-x bindings
;;          ("C-x b"   . consult-buffer)
;;          ("C-x 4 b" . consult-buffer-other-window)
;;          ("C-x r b" . consult-bookmark)
;;          ("C-x M-:" . consult-complex-command)
;;          ;; Misc
;;          ("M-y"     . consult-yank-pop)
;;          ("C-c h"   . consult-history)
;;          ("C-c m"   . consult-mode-command)
;;          ;; M-g: goto
;;          ("M-g g"   . consult-goto-line)
;;          ("M-g M-g" . consult-goto-line)
;;          ("M-g o"   . consult-outline)
;;          ("M-g m"   . consult-mark)
;;          ("M-g k"   . consult-global-mark)
;;          ("M-g i"   . consult-imenu)
;;          ("M-g I"   . consult-imenu-multi)
;;          ("M-g e"   . consult-compile-error)
;;          ("M-g f"   . consult-flymake)
;;          ;; M-s: search
;;          ("M-s d"   . consult-find)
;;          ("M-s r"   . consult-ripgrep)     ; requires ripgrep
;;          ("M-s g"   . consult-grep)
;;          ("M-s G"   . consult-git-grep)
;;          ("M-s l"   . consult-line)
;;          ("M-s L"   . consult-line-multi)
;;          ("M-s k"   . consult-keep-lines)
;;          ("M-s u"   . consult-focus-lines)
;;          ;; Isearch integration
;;          ("M-s e"   . consult-isearch-history)
;;          :map isearch-mode-map
;;          ("M-e"     . consult-isearch-history)
;;          ("M-s l"   . consult-line)
;;          ;; Minibuffer history
;;          :map minibuffer-local-map
;;          ("M-s"     . consult-history)
;;          ("M-r"     . consult-history))
;;   :hook (completion-list-mode . consult-preview-at-point-mode)
;;   :init
;;   ;; Use Consult for xref locations
;;   (setq xref-show-xrefs-function       #'consult-xref
;;         xref-show-definitions-function #'consult-xref)
;;   ;; Nicer register preview
;;   (setq register-preview-delay 0.5)
;;   (advice-add #'register-preview :override #'consult-register-window)
;;   :config
;;   ;; Only preview the expensive sources when you press M-.
;;   (consult-customize
;;    consult-ripgrep consult-git-grep consult-grep
;;    consult-bookmark consult-recent-file consult-xref
;;    :preview-key "M-.")
;;   (setq consult-narrow-key "<"))

;; ;;;; Embark: context actions on the thing at point / candidate
;; (use-package embark
;;   :bind (("C-."   . embark-act)        ; act on the candidate or thing at point
;;          ("C-;"   . embark-dwim)       ; run the default action
;;          ("C-h B" . embark-bindings))  ; browse active key bindings
;;   :init
;;   ;; Use Embark for the prefix-key help (C-x C-h etc.)
;;   (setq prefix-help-command #'embark-prefix-help-command)
;;   :config
;;   ;; Hide the mode line in Embark Collect buffers
;;   (add-to-list 'display-buffer-alist
;;                '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
;;                  nil
;;                  (window-parameters (mode-line-format . none)))))

;; ;; Make Embark and Consult work together (e.g. live preview in collect buffers)
;; (use-package embark-consult
;;   :after (embark consult)
;;   :hook (embark-collect-mode . consult-preview-at-point-mode))


;;;;;;;;;;;;;;;;;;;; Functions

;; Delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'init)
;;; init.el ends here

;;;;;;;;;;;;;;;;;;;; Python

(add-hook 'python-mode-hook '(lambda () (setq python-indent 2)))
