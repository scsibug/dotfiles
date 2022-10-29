(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/"))

;; install use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;;
(require 'use-package)

;; setup a private directory in .emacs.d
(defconst private-dir (expand-file-name "private"
					user-emacs-directory))
;; setup a temp cache directory
(defconst temp-dir (format "%s/cache" private-dir)
  "elisp temp directories")

;; Use UTF-8
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)
(set-terminal-coding-system  'utf-8)
(set-keyboard-coding-system  'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system        'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; Emacs customizations
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

;; Use a dedicated file for customizations
(setq custom-file "~/.emacs.d/.custom.el")
(load custom-file)

;; Bookmarks
(setq
 ;; persistent bookmarks, save on every change
 bookmark-save-flag 1
 bookmark-default-file (concat temp-dir "/bookmarks"))



;; Backup in a dedicated place
(setq
 history-length                     1000
 backup-inhibited                   nil
 make-backup-files                  t
 auto-save-default                  t
 auto-save-list-file-name           (concat temp-dir "/autosave")
 create-lockfiles                   nil
 backup-directory-alist            `((".*" . ,(concat temp-dir "/backup/")))
 auto-save-file-name-transforms    `((".*" ,(concat temp-dir "/auto-save-list/") t)))
;; Create necessary directory
(unless (file-exists-p (concat temp-dir "/auto-save-list"))
		       (make-directory (concat temp-dir "/auto-save-list") :parents))

;; When the file on disk changes, auto-revert the buffer
(global-auto-revert-mode t)

;; Delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Detect and provide performance mitigations for files with very long
;; lines
(global-so-long-mode)


;; Typing over a selection deletes it
(delete-selection-mode t)

;; Show column numbers in the mode line
(column-number-mode)

;; Show line numbers on left-hand side
(global-display-line-numbers-mode)

(provide 'base)
