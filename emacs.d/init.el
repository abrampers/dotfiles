;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar abram/default-font-size 150)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; Scroll compilation buffer whenever output came
(setq compilation-scroll-output t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(when (eq system-type 'darwin)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))

(set-face-attribute 'default nil :font "Monego" :height abram/default-font-size)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
                dired-sidebar-mode-hook
                compilation-mode-hook
                term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(defvar abram/current-numbering-style-index)
(setq abram/current-numbering-style-index 0)
(defvar abram/numbering-styles)
(setq abram/numbering-styles '(t nil relative))

(defun abram/cycle-numbering-style ()
  (interactive)
  (let ((next-numbering-index (% (+ abram/current-numbering-style-index 1) (length abram/numbering-styles))))
    (let ((next-numbering-style (nth next-numbering-index abram/numbering-styles)))
      (setq display-line-numbers next-numbering-style)
      (setq abram/current-numbering-style-index next-numbering-index))))

(use-package command-log-mode)

(use-package doom-themes)

(load-theme 'doom-nord t)

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package nyan-mode
  :init (setq nyan-animate-nyancat t
              nyan-wavy-trail t)
  :config (nyan-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         ;; ("M-x" . counsel-M-x) ;; Check if without this M-x still go to counsel
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-copy-env "GOPATH")
    (exec-path-from-shell-initialize)))

(use-package undo-tree
  :config (global-undo-tree-mode))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
 :after evil
 :config
 (evil-collection-init))

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000)
  :custom
  (vterm-buffer-name-string "vterm [%s]"))

(setq insert-directory-program "gls" dired-use-ls-dired t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode))

(use-package dired-sidebar
  :commands (dired-sidebar-toggle-sidebar)
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode)))))

(defun abram/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Monego" :weight 'regular :height (cdr face))))

(defun abram/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . abram/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files (list org-directory))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("Archived.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/org/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/org/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/org/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/org/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/org/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (abram/org-font-setup))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun abram/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . abram/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; Automatically tangle our Emacs.org config file when we save it
(defun abram/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/emacs.d/configuration.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'abram/org-babel-tangle-config)))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Code")
    (setq projectile-project-search-path '("~/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(evil-global-set-key 'normal (kbd "tp") 'projectile-test-project)

(defun abram/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project))
  (setq lsp-eldoc-enable-hover nil)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . abram/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :custom
  (lsp-file-watch-threshold 2000)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-ivy)

(defun abram/evil-lsp-keybindings ()
  (evil-local-set-key 'normal (kbd "gd") 'lsp-find-definition)
  (evil-local-set-key 'normal (kbd "gi") 'lsp-find-implementation)
  (evil-local-set-key 'normal (kbd "gr") 'lsp-find-references)
  (evil-local-set-key 'normal (kbd "gy") 'lsp-find-type-definition)
  (evil-local-set-key 'normal (kbd ",r") 'lsp-rename))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-tooltip-align-annotations t)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode)
  :init
  (setq company-box-enable-icon nil))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-magit
  :after magit)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(use-package whitespace
  :hook ((prog-mode . whitespace-mode)
         (text-mode . whitespace-mode))
  :init
  (setq whitespace-style '(face tabs empty trailing tab-mark)))

(use-package evil-commentary
  :config
  (evil-commentary-mode))

(use-package smartparens)

(use-package evil-smartparens)

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(add-hook 'prog-mode-hook 'electric-pair-local-mode)

(use-package go-mode
  :mode "\\.go\\'"
  :hook ((go-mode . lsp-deferred)
         (go-mode . abram/evil-lsp-keybindings))
  :init (setq gofmt-command "goimports")
  :config (add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-playground :ensure t)

(add-hook 'go-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)))

(projectile-register-project-type 'go '("go.mod")
                                  :project-file "go.mod"
                                  :compile "make build"
                                  :test "make test"
                                  :test-suffix "_test")

(defun abram/go-test-keybindings ()
  (evil-local-set-key 'normal (kbd "tt") 'go-test-current-test)
  (evil-local-set-key 'normal (kbd "tf") 'go-test-current-file)
  (evil-local-set-key 'normal (kbd "ts") 'go-test-current-project)
  (evil-local-set-key 'normal (kbd "tc") 'go-test-current-coverage))

(use-package gotest
  :hook (go-mode . abram/go-test-keybindings))

(add-hook 'ruby-mode-hook
          (lambda ()
            (abram/evil-lsp-keybindings)
            (lsp)))

(use-package clojure-mode
  :hook ((clojure-mode . smartparens-strict-mode)
         (clojure-mode . evil-smartparens-mode)))

(use-package cider
  :hook ((clojure-mode . cider-mode)
         (clojure-mode . company-mode)
         (cider-repl-mode . company-mode))
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map cider-mode-map
         ("<tab>" . company-indent-or-complete-common)))

(defun abram/cider-format-for-clj ()
  (when (member (file-name-extension (buffer-file-name))
                '("clj" "cljs" "cljc"))
    (cider-format-buffer)))

(add-hook 'cider-mode-hook
          (lambda () (add-hook 'before-save-hook #'abram/cider-format-for-clj)))

(defun abram/emacs-lisp-mode-hooks ()
  (smartparens-strict-mode)
  (evil-smartparens-mode))

(add-hook 'emacs-lisp-mode-hook 'abram/emacs-lisp-mode-hooks)

(add-to-list 'auto-mode-alist '("zshrc\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.zshrc\\.local\\'" . sh-mode))

(use-package yaml-mode)

(use-package general
  :config
  (general-create-definer abram/leader-keys-map
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (abram/leader-keys-map
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Make SPC-# to cycle numbering modes
(abram/leader-keys-map
    "#" 'abram/cycle-numbering-style)

(abram/leader-keys-map
  "g"  '(:ignore t :which-key "org-mode helper prefixes")
  "ga" 'org-agenda
  "gc" 'org-capture)

(abram/leader-keys-map
    "o" 'delete-other-windows)

(defun abram/switch-to-most-recent-buffer ()
  "Switch to previously open buffer. Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(evil-global-set-key 'normal (kbd ",g") 'abram/switch-to-most-recent-buffer)

(evil-global-set-key 'normal (kbd ",b") 'previous-buffer)
(evil-global-set-key 'normal (kbd ",f") 'next-buffer)

(evil-collection-define-key 'normal 'dired-mode-map
  "h" 'dired-single-up-directory
  "l" 'dired-single-buffer
  "H" 'dired-hide-dotfiles-mode)

(evil-global-set-key 'normal (kbd ",w") 'evil-write)

(evil-global-set-key 'normal (kbd "C-p") 'projectile--find-file)

(abram/leader-keys-map
  "f" 'counsel-projectile-rg)

(add-hook 'prog-mode-hook
          (lambda ()
            (evil-local-set-key 'normal (kbd ",a") 'projectile-toggle-between-implementation-and-test)
            (evil-ex-define-cmd "A" 'projectile-toggle-between-implementation-and-test)
            (evil-ex-define-cmd "AV" 'projectile-find-implementation-or-test-other-window)))


