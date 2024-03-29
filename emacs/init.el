;; inspired by https://github.com/purcell/emacs.d
(add-to-list 'load-path (concat user-emacs-directory "elisp"))

;; Use a dedicated file for customizations
(setq custom-file "~/.emacs.d/.custom.el")
(load custom-file)

;; Load other modules
(require 'startup)
(require 'base)
(require 'base-theme)
(require 'base-extensions)
(require 'base-functions)
(require 'base-global-keys)
(require 'ext-org)
(require 'lang-rust)

;; enable downcase-region command (C-x C-l)
(put 'downcase-region 'disabled nil)
