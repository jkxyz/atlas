(setq tab-always-indent 'complete
      create-lockfiles nil
      make-backup-files nil)

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(use-package simple
  :config
  ;; Use spaces for indentation by default
  (setq-default indent-tabs-mode nil))

(use-package evil
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-undo-system 'undo-redo "Use Emacs built-in undo system")

  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil

  :config
  (evil-collection-init))

(use-package doom-themes
  :config
  (load-theme 'doom-one t))

(use-package treesit
  :mode
  ("\\.js\\'" . js-ts-mode)
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.tsx\\'" . tsx-ts-mode))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package corfu
  :custom
  (corfu-auto t)

  :config
  (global-corfu-mode 1))

(use-package js
  :custom
  (js-indent-level 2))

(use-package display-line-numbers
  :config
  (global-display-line-numbers-mode 1))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package apheleia
  :config
  (apheleia-global-mode 1))

(use-package which-key
  :config
  (which-key-mode 1))

(use-package lsp-mode
  :custom
  (lsp-keymap-prefix "C-c l")

  :commands lsp)

(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package clojure-ts-mode
  :mode ("\\.clj\\'"
         "\\.cljs\\'"
         "\\.cljc\\'"))

(use-package cider
  :hook clojure-ts-mode)

(use-package smartparens-mode
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

(use-package evil-cleverparens
  :hook smartparens-mode)
