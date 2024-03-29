;; ~/.emacs.d/init.el

;; Time-stamp: <2024-03-28 18:54:58 david.hisel>

;;; Commentary:

;; Some cool Emacs packages to consider https://github.com/emacs-tw/awesome-emacs

;; Personalize these variables
(setq user-full-name "David Hisel")
(setq user-documents-dir (expand-file-name "Documents/" (getenv "HOME")))

;; Destination where you store Org-mode docs
(setq user-org-directory (expand-file-name "org/" user-documents-dir))

;; Destination where to store your todo.txt file
(setq my:todotxt-file (expand-file-name "Documents/todo.txt" (getenv "HOME")))

;;; Code:

;; Define the file where to save customizations
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))


;;; Startup
(setq inhibit-startup-message t
      initial-scratch-message "# Scratch"
      initial-scratch-buffer nil
      initial-buffer-choice nil
      default-tab-width 4
      c-electric-flag nil
      time-stamp-start "\\(\\([cC]re\\|[uU]p[dD]\\|[dD]\\)?ated\\|[tT]ime-stamp\\|[mM]odified\\):\\([ \t]+\\)?[\"<]"
      time-stamp-end "\\\\?[\">]")
;; VSCode extension only has this: [cC]reated *:
;;         [dD]ated:
;;    [uU]p[dD]ated:
;;       [cC]reated:
;;      [mM]odified:
;;    [tT]ime-stamp:
;; (([cC]re|[uU]p[dD]|[dD])?ated|[tT]ime-stamp|[mM]odified):[ \t]+?[\"<]

(add-hook 'before-save-hook 'time-stamp) ; time-stamp.el
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-region 'disabled nil)


;;; Appearance

(set-frame-name "Dromedary")
(set-face-attribute 'default nil :height 145)
(add-to-list 'default-frame-alist '(background-color . "black"))
(add-to-list 'default-frame-alist '(foreground-color . "white"))
(add-to-list 'default-frame-alist '(cursor-color . "red"))
;; (set-background-color "white")
;; (set-foreground-color "black")
;; (set-background-color "black")
;; (set-foreground-color "white")

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tooltip-mode) (tooltip-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'fringe-mode) (fringe-mode 0))
(if (fboundp 'display-time-mode) (display-time-mode 1))

(global-font-lock-mode 1)
(menu-bar-no-scroll-bar)
(line-number-mode t)
(column-number-mode t)
(transient-mark-mode 1)
(blink-cursor-mode 0)
(defalias 'yes-or-no-p 'y-or-n-p)


;; When shell output gets too long it pops up a buffer warning
;; this diables that message
(setq warning-suppress-types (quote ((undo discard-info)))
      ediff-split-window-function #'split-window-horizontally)


;;; Global Key Bindings
(global-set-key (kbd "C-x o")      #'next-multiframe-window)
(global-set-key (kbd "C-x p")      #'previous-multiframe-window)

(global-set-key (kbd "C-h C-b")    #'browse-url-at-point)
(global-set-key (kbd "C-h C-c")    #'compile)
(global-set-key (kbd "C-h C-d")    #'treemacs)
(global-set-key (kbd "C-h g")      #'magit-status)
(global-set-key (kbd "C-h C-g")    #'grep-find)
(global-set-key (kbd "C-h C-w")    #'clipboard-kill-ring-save)
(global-set-key (kbd "C-h C-y")    #'clipboard-yank)
(global-set-key (kbd "C-h 6") #'(lambda () ; insert date stamp at point
				  (interactive)
				  (insert (format-time-string "%Y-%m-%d %A"))))
(global-set-key (kbd "C-h ^") #'(lambda () ; insert timestamp at point
				  (interactive)
				  (insert (format-time-string "%Y-%m-%dT%H:%M:%S"))))
(global-set-key (kbd "C-h 7") #'sql-send-region)
(global-set-key (kbd "C-h 8") #'(lambda ()
  				  (interactive)
  				  (switch-to-buffer 
  				   (find-file-noselect
  				    (expand-file-name "init.el" user-emacs-directory)))))
(global-set-key (kbd "C-h 9") #'toggle-frame-maximized)
(global-set-key (kbd "C-h C-9") #'my:toggle-transparency)

(global-set-key (kbd "C-h C-/") #'(lambda ()
   				    (interactive)
   				    (switch-to-buffer 
   				     (find-file-noselect
   				      (expand-file-name "Links.org" user-org-directory)))))
(global-set-key (kbd "C-h C-n") #'(lambda ()
  				    (interactive)
  				    (switch-to-buffer
  				     (find-file-noselect
  				      (expand-file-name "Notes.org" user-org-directory)))))
(global-set-key (kbd "C-h C-r") #'(lambda ()
  				    (interactive)
  				    (switch-to-buffer
  				     (find-file-noselect
  				      (expand-file-name "Rolo.org" user-org-directory)))))
(global-set-key (kbd "C-h C-o") #'(lambda ()
  				    (interactive)
  				    (switch-to-buffer 
  				     (find-file-noselect
  				      (read-file-name "Org File: " user-org-directory)))))

;; (global-set-key (kbd "C-h C-9") #'my:toggle-transparency)
(set-frame-parameter nil 'alpha '(100 100)) ; set initial state to opaque
(defun my:toggle-transparency ()
  "Toggle transparency of current frame.
   TODO: add functionality to take a parameter for transparency level"
  (interactive)
  (if (/= (cadr (frame-parameter nil 'alpha)) 100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(50 50))))


;; Based on snippet from <http://wordaligned.org/articles/ignoring-svn-directories>
;; Use ctrl-x backtick to jump to the right place in the matching file.
(setq grep-find-command
      "find . -path '*/.git' -prune -o -type f -print | xargs -e grep -I -n -e ")

;; From the Emacs FAQ
;; '%' finds matching paren
(global-set-key (kbd "%") #'match-paren)
(show-paren-mode 1)
(defun match-paren (arg) 
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond 
   ((looking-at "[[{(<]") (forward-list 1) (backward-char 1))
   ((looking-at "[\]})>]") (forward-char 1) (backward-list 1))
   (t (self-insert-command (or arg 1)))))


;;; Packages

;; To list packages M-x list-packages RET

;; Required to get package-refresh-contents to work with elpa
(setq gnutls-algorithm-priority "normal:-vers-tls1.3")

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)


(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package hyperbole
  :ensure t
  :config
  (hyperbole-mode 1)
  :custom
  (hyrolo-file-list 
   '((expand-file-name "Links.org" user-org-directory)
     (expand-file-name "Notes.org" user-org-directory)
     (expand-file-name "Rolo.org" user-org-directory))))

(use-package csv-mode)
(use-package json-navigator)
(use-package yaml-mode)

(use-package magit)
(use-package magit-org-todos
  :config
  (magit-org-todos-autoinsert))

(use-package buffer-move
  :bind
  (("C-h C-h" . buf-move-left)
   ("C-h C-j" . buf-move-down)
   ("C-h C-k" . buf-move-up)
   ("C-h C-l" . buf-move-right)))

;; https://github.com/todotxt/todo.txt
;; https://github.com/rpdillon/todotxt.el
;; (use-package todotxt
;;   :bind
;;   (("C-h t" . todotxt))
;;   :custom
;;   (todotxt-file my:todotxt-file))

;; https://github.com/avillafiorita/todotxt-mode
(use-package todotxt-mode
  :bind
  (("C-h t" . todotxt-open-file))
  ;; (define-key global-map "\C-ct" 'todotxt-add-todo)
  :config
  (setq todotxt-default-file my:todotxt-file)
  (defun my:todotxt-open-file()
    "Look in current dir for todo.txt file, then open default if not exist in cur dir."
    (interactive)
    (buffer-file-name)
    (find-file todotxt-default-file)
    (todotxt-mode))
  (defalias 'todotxt-open-file 'my:todotxt-open-file))

;; 
;;  https://www.gnu.org/software/emacs/manual/html_node/use-package/Binding-in-keymaps.html
(use-package hl-todo
  :custom
  (hl-todo-keyword-faces
   '(("TODO"   . "#FF0000")
     ("FIXME"  . "#FF0000")
     ("DEBUG"  . "#A020F0")
     ("GOTCHA" . "#FF4500")
     ("STUB"   . "#1E90FF")))
  
  :bind
  (:map hl-todo-mode-map
	("C-c p" . hl-todo-previous)
	("C-c n" . hl-todo-next)
	("C-c o" . hl-todo-occur)
	("C-c i" . hl-todo-insert)))




(use-package auto-complete
  :init (ac-config-default))

(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.json\\'" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

;; Go - lsp-mode <https://geeksocket.in/posts/emacs-lsp-go/>
;;
;; Some useful keybindings and functions
;; M-.                     -- jump to the definition of a symbol
;; M-,                     -- to get back
;; M-x lsp-find-references -- to get a list of places where the current symbol is used
;; M-x lsp-rename          -- can be used to rename a symbol at all the places
(use-package go-mode
  :config
  (defun lsp-go-install-save-hooks ()
    ;;(add-hook 'before-save-hook #'gofmt-before-save)
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

  ;; Start LSP Mode and YASnippet mode
  (add-hook 'go-mode-hook #'lsp-deferred)
  (add-hook 'go-mode-hook #'yas-minor-mode)
  (auto-complete-mode nil))
(use-package lsp-mode)
(use-package lsp-ui)

;; https://github.com/dominikh/go-mode.el
;;(setq gofmt-command "goimports")

(use-package company
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1))

(use-package yasnippet
  :init
  (yas-global-mode 1))

;; Find File At Point ("FFAP") (ffap.el)
(use-package ffap
  :init
  (ffap-bindings))

;; Org mode
(use-package org
  :custom
  (org-directory user-org-directory)
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)))

(use-package plantuml-mode
  :config
  (if (not (file-exists-p plantuml-jar-path))
      (plantuml-download-jar))
  :custom
  (plantuml-jar-path (expand-file-name "plantuml.jar" user-emacs-directory))
  (org-plantuml-jar-path plantuml-jar-path)
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t))))

;; Markdown
;;
;; https://jblevins.org/projects/markdown-mode/
;; Using npm "markdown-it" with "meta-header" and "plantuml-ex" plugins.
;; Steps to install markdown-it with plugins:
;;	npm install markdown-it --save
;;	npm install markdown-it-cli --save
;;	npm install markdown-it-meta-header --save
;;	npm install markdown-it-plantuml-ex --save
;;      # use the latest plantuml.jar
;; 	curl -sLJO https://github.com/plantuml/plantuml/releases/download/v1.2023.9/plantuml.jar -o plantuml.jar
;;	mv plantuml.jar ./node_modules/markdown-it-plantuml-ex/lib/plantuml.jar
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-command "npx markdown-it-cli")
  (markdown-command-needs-filename t)
  :config
  ;; update preview buffer when md file is saved
  (add-hook 'before-save-hook 'markdown-live-preview-re-export)
  ;; C-c C-c a -- align table
  (define-key markdown-mode-command-map (kbd "a") 'markdown-table-align))


;; Theme
;; https://draculatheme.com/emacs/
;;(use-package dracula-theme
;;  :config (load-theme 'dracula t))

;; https://www.emacswiki.org/emacs/Desktop
(use-package desktop
  :config
  (defun my:desktop-save ()
    (interactive)
    ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
    (if (eq (desktop-owner) (emacs-pid))
	(desktop-save desktop-dirname)))
  (add-hook 'auto-save-hook 'my:desktop-save)
  (desktop-save-mode 1))

;; EmacsServer  "server.el"
;; Connect term via $ emacsclient -t   # exit with C-x 5 0
;; Connect  gui via $ emacsclient FILE # exit with C-x #
(setq server-socket-dir (format "/tmp/emacs/%d" (user-uid)))
(server-start)


;; == Mac OS X Settings ==
(when (eq system-type 'darwin)

  ;; switch option <-> command key modifiers ... most keyboards have
  ;; cmd-key closer to spacebar making it easier to use cmd-key as
  ;; meta key
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta)

  (setq browse-url-browser-function 'browse-url-default-macosx-browser))


;; == Windows Settings ==
(when (eq system-type 'windows-nt)
  (setq browse-url-browser-function 'browse-url-default-windows-browser))


;;; __END__
