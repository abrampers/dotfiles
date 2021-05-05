;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; The default is 800 kilobytes.  Measured in bytes.
  (setq gc-cons-threshold (* 50 1000 1000))

  (defun abram/display-startup-time ()
    (message "Emacs loaded in %s with %d garbage collections."
             (format "%.2f seconds"
                     (float-time
                       (time-subtract after-init-time before-init-time)))
             gcs-done))

(add-hook 'emacs-startup-hook #'abram/display-startup-time)

(let ((private-init-file "~/.emacs.d/private-init.el"))
  (when (file-exists-p private-init-file)
    (load-file private-init-file)))

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

(use-package doom-themes)
(use-package nord-theme)
(use-package gruvbox-theme)
(use-package material-theme)
(use-package seti-theme)

(load-theme 'gruvbox-dark-medium t)

(toggle-frame-fullscreen)

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

(when (eq system-type 'darwin)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))

;; You will most likely need to adjust this font size for your system!
(defvar abram/default-font-size 140)

(set-face-attribute 'default nil :font "SauceCodePro Nerd Font Mono" :height abram/default-font-size)

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

(add-hook 'prog-mode-hook 'hl-line-mode)

(setq initial-major-mode 'org-mode)

(setq initial-scratch-message "\
# This buffer is for notes you don't want to save, and for org-mode.
# If you want to create a file, visit that file with C-x C-f,
# then enter the text in that file's own buffer.")

(use-package xterm-color)

(setq compilation-environment '("TERM=xterm-256color"))

(defun abram/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))

(advice-add 'compilation-filter :around #'abram/advice-compilation-filter)

(use-package auto-package-update
  :commands auto-package-update-now)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :custom
  (exec-path-from-shell-arguments '("-l"))
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-copy-env "PYENV_ROOT")
  (exec-path-from-shell-initialize))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package command-log-mode)

(use-package all-the-icons)

(setq display-time-format "(%I.%M %p) [%A %b %d, %Y]")
(setq display-time-load-average-threshold 4)
(display-time-mode)
(display-battery-mode)


(use-package doom-modeline
  :custom
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-modal-icon t)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-indent-info t)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 30)
  (doom-modeline-env-version t)
  (doom-modeline-irc-stylize 'identity)
  (doom-modeline-github-timer nil)
  (doom-modeline-gnus-timer nil)
  :init
  (doom-modeline-mode 1))

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
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         ("M-x" . counsel-M-x) ;; Check if without this M-x still go to counsel
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package undo-tree
  :after evil
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

(use-package dired-single
  :commands (dired dired-jump))

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
                  (org-level-4 . 1.05)
                  (org-level-5 . 1.05)
                  (org-level-6 . 1.05)
                  (org-level-7 . 1.05)
                  (org-level-8 . 1.05)))
    (set-face-attribute (car face) nil :font "Monego" :weight 'regular :height (cdr face))))

(defun abram/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . abram/org-mode-setup)
  :custom ((org-image-actual-width nil)
           (org-startup-folded 'content))
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
    '((sequence "TODO(t)" "NEXT(n)" "WIP(w!)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?e)
       ("@home" . ?H)
       ("@work" . ?W)
       ("@spiritual" . ?s)
       ("@personal" . ?p)
       ("learn" . ?l)
       ("agenda" . ?a)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("emacs" . ?E)
       ("vim" . ?V)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "WIP"
        ((org-agenda-overriding-header "Current Tasks")))
      (tags-todo "+PRIORITY_QUADRANT=1"
        ((org-agenda-overriding-header "Quadrant 1 (Important + Urgent)")
         (org-agenda-max-todos 5)))
      (tags-todo "+PRIORITY_QUADRANT=2"
        ((org-agenda-overriding-header "Quadrant 2 (Important + Not Urgent)")
         (org-agenda-max-todos 5)))
      (tags-todo "+PRIORITY_QUADRANT=3"
        ((org-agenda-overriding-header "Quadrant 3 (Not Important + Urgent)")
         (org-agenda-max-todos 5)))
      (tags-todo "+PRIORITY_QUADRANT=4"
        ((org-agenda-overriding-header "Quadrant 4 (Not Important + Not Urgent)")
         (org-agenda-max-todos 5)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("p" "Prioritization"
     ((tags-todo "+PRIORITY_QUADRANT=1"
        ((org-agenda-overriding-header "Quadrant 1 (Important + Urgent)")))
      (tags-todo "+PRIORITY_QUADRANT=2"
        ((org-agenda-overriding-header "Quadrant 2 (Important + Not Urgent)")))
      (tags-todo "+PRIORITY_QUADRANT=3"
        ((org-agenda-overriding-header "Quadrant 3 (Not Important + Urgent)")))
      (tags-todo "+PRIORITY_QUADRANT=4"
        ((org-agenda-overriding-header "Quadrant 4 (Not Important + Not Urgent)")))
      (tags-todo "+PRIORITY_QUADRANT=\"\""
        ((org-agenda-overriding-header "Not prioritized yet")))))

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
      ("tt" "General Task" entry (file+olp "~/org/Inbox.org" "Inbox")
           "* TODO %?\n%U\n\n  %i" :empty-lines 0)
      ("tp" "Personal Task" entry (file+olp "~/org/Personal.org" "Personal")
           "* TODO %? :@personal:\n%U\n\n  %i" :empty-lines 0)
      ("te" "Errand" entry (file+olp "~/org/Inbox.org" "Inbox")
           "* TODO %? :@errand:\n%U\n\n  %i" :empty-lines 0)
      ("tw" "Work Task" entry (file+olp "~/org/Work.org" "Work")
           "* TODO %? :@work:\n%U\n%a\n%i" :empty-lines 0)
      ("ti" "Implementation Task" entry (file+olp "~/org/Work.org" "Work")
           "* TODO %? :implementation:\n%U\n%a\n%i" :empty-lines 0)

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

(use-package org-wild-notifier
  :config
  (setq alert-default-style 'osx-notifier)
  :init
  (org-wild-notifier-mode))

(use-package restclient
  :mode (("\\.http\\'" . restclient-mode)))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  (projectile-switch-project-action #'counsel-fzf)
  :bind-keymap
  ("C-c p" . projectile-command-map))

(evil-global-set-key 'normal (kbd "tp") 'projectile-test-project)

(defun abram/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(symbols))
  (setq lsp-lens-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-eldoc-enable-hover t)
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
  (lsp-ui-doc-enable nil)
  (lsp-signature-auto-activate '(:on-trigger-char :after-completion)))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(defun abram/evil-lsp-keybindings ()
  (evil-local-set-key 'normal (kbd "gd") 'lsp-find-definition)
  (evil-local-set-key 'normal (kbd "gi") 'lsp-find-implementation)
  (evil-local-set-key 'normal (kbd "gr") 'lsp-find-references)
  (evil-local-set-key 'normal (kbd "gy") 'lsp-find-type-definition)
  (evil-local-set-key 'normal (kbd ",r") 'lsp-rename))

(use-package dap-mode
  :commands dap-debug
  :custom 
  (dap-auto-configure-features '(locals expressions tooltip))
  (dap-auto-show-output nil)
  :config
  (require 'dap-go)
  (dap-go-setup))

(add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))

(use-package flycheck)

(use-package go-mode
  :mode "\\.go\\'"
  :hook ((go-mode . lsp-deferred)
         (go-mode . abram/evil-lsp-keybindings)
         (go-mode . electric-pair-local-mode))
  :init 
  (setq gofmt-command "goimports")
  (flycheck-mode)
  :config (add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-playground
  :commands go-playground)

(add-hook 'go-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)))

(with-eval-after-load 'projectile

  (projectile-register-project-type 'go '("go.mod")
                                    :project-file "go.mod"
                                    :compile "make build"
                                    :test "make test"
                                    :test-suffix "_test"))

(defun abram/go-test-current-project ()
  "Launch go test on the current project."
  (interactive)
  (let ((packages (cl-remove-if (lambda (s) (s-contains? "/vendor/" s))
                                (s-split "\n"
                                       (shell-command-to-string (format "cd %s && go list ./..." (projectile-project-root)))))))
    (go-test--go-test (s-join " " packages))))

(defun abram/go-test-keybindings ()
  (require 'gotest)
  (evil-local-set-key 'normal (kbd "tt") 'go-test-current-test)
  (evil-local-set-key 'normal (kbd "tf") 'go-test-current-file)
  (evil-local-set-key 'normal (kbd "t.") 'go-test-current-test-cache)
  (evil-local-set-key 'normal (kbd "ts") 'abram/go-test-current-project))

(use-package gotest
  :after go-mode
  :hook (go-mode . abram/go-test-keybindings)
  :init
  (setq go-test-args "-p 1"))

(defun abram/go-test-debug ()
    (interactive)
    (let ((func-name (nth 1 (go-test--get-current-test-info)))
          (suite-name (nth 0 (go-test--get-current-test-info))))
      (if (= (length suite-name) 0)
        (dap-debug 
            (list :type "go"
                :request "launch"
                :name (format "Launch test %s" func-name)
                :mode "auto"
                :program default-directory
                :buildFlags nil
                :args (format "-test.v -test.run %s" func-name)
                :env nil
                :envFile nil))
        (dap-debug 
            (list :type "go"
                :request "launch"
                :name (format "Launch test %s.%s" suite-name func-name)
                :mode "auto"
                :program default-directory
                :buildFlags nil
                :args (format "-test.v -testify.m %s" func-name)
                :env nil
                :envFile nil)))))

              
(add-hook 
  'go-mode-hook
  (lambda ()
    (evil-local-set-key 'normal (kbd "td") 'abram/go-test-debug)))

(add-hook 'ruby-mode-hook
          (lambda ()
            (abram/evil-lsp-keybindings)
            (lsp)))

(defun abram/rspec-keybindings ()
  (evil-local-set-key 'normal (kbd "tt") 'rspec-verify-single)
  (evil-local-set-key 'normal (kbd "tf") 'rspec-verify-matching)
  (evil-local-set-key 'normal (kbd "t.") 'rspec-rerun)
  (evil-local-set-key 'normal (kbd "ts") 'rspec-verify-all))

(use-package rspec-mode
  :hook (ruby-mode . abram/rspec-keybindings))

(use-package clojure-mode
  :mode "\\.clj\\'")

(use-package cider
  :hook ((clojure-mode . cider-mode)
         (clojure-mode . company-mode)
         (cider-repl-mode . company-mode))
  :bind (:map company-active-map
         ("TAB" . company-complete-selection))
        (:map cider-mode-map
         ("TAB" . company-indent-or-complete-common)))

(defun abram/cider-format-for-clj ()
  (when (member (file-name-extension (buffer-file-name))
                '("clj" "cljs" "cljc"))
    (cider-format-buffer)))

(add-hook 'cider-mode-hook
          (lambda () (add-hook 'before-save-hook #'abram/cider-format-for-clj)))

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(add-hook 'c-mode-hook 'electric-pair-local-mode)
(add-hook 'c++-mode-hook 'electric-pair-local-mode)
(add-hook 'objc-mode-hook 'electric-pair-local-mode)
(add-hook 'cuda-mode-hook 'electric-pair-local-mode)

(use-package cmake-font-lock
  :mode ("CMakeLists\\.txt\\'" .  cmake-mode))

(setq lsp-pyls-plugins-jedi-use-pyenv-environment t)

(use-package pyenv-mode
  :hook ((python-mode . pyenv-mode)
         (python-mode . lsp-deferred)))

(add-to-list 'auto-mode-alist '("zshrc\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.zshrc\\.local\\'" . sh-mode))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map
        ("C-j" . company-select-next))
  (:map lsp-mode-map
        ("TAB" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-tooltip-align-annotations t)
  (company-idle-delay 0.0))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :init
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package git-gutter
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
  (global-git-gutter-mode t))

(use-package browse-at-remote
  :commands browse-at-remote
  :bind (("C-c g g" . browse-at-remote)))

(use-package rainbow-delimiters
  :hook ((clojure-mode . rainbow-delimiters-mode)
         (lisp-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(use-package whitespace
  :hook ((prog-mode . whitespace-mode)
         (text-mode . whitespace-mode))
  :init
  (setq whitespace-style '(face tabs empty trailing tab-mark)))

(use-package evil-commentary
  :hook ((prog-mode . evil-commentary-mode)
         (org-mode . evil-commentary-mode))
  :config
  (evil-commentary-mode))

(use-package smartparens
  :hook ((clojure-mode . smartparens-strict-mode)
         (emacs-lisp-mode . smartparens-strict-mode)))

(use-package evil-smartparens
  :hook ((smartparens-mode . evil-smartparens-mode)
         (smartparens-strict-mode . evil-smartparens-mode)))

(use-package evil-surround
  :commands
  (evil-surround-region evil-surround-edit evil-Surround-edit evil-Surround-region)
  :config
  (global-evil-surround-mode 1))

(use-package lsp-origami
  :hook (lsp-mode . lsp-origami-try-enable))

(use-package makefile-executor
  :commands makefile-executor-execute-project-target
  :config
  (add-hook 'makefile-mode-hook 'makefile-executor-mode))

(defun abram/make-test-current-project ()
  "Launch make test on the current project"
  (interactive)

  (let ((filename (format "%s/Makefile" (projectile-project-root))))
    (makefile-executor-execute-target filename "test")))

(add-hook
  'prog-mode-hook
  (lambda ()
    (evil-local-set-key 'normal (kbd "m SPC") 'makefile-executor-execute-project-target)
    (evil-local-set-key 'normal (kbd "m t") 'abram/make-test-current-project)))

(use-package ox-hugo
  :after ox)

(with-eval-after-load 'org-capture
    (defun abram/org-hugo-new-subtree-post-capture-template ()
      "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
      (let* ((title (read-from-minibuffer "Post Title: "))
             (fname (org-hugo-slug title)))
        (mapconcat #'identity
                   `(
                     ,(concat "* TODO " title)
                     ":PROPERTIES:"
                     ,(concat ":EXPORT_FILE_NAME: " fname)
                     ":END:"
                     "#+toc: headlines 1 local"
                     "\n"
                     "%?\n\n\n")
                   "\n")))

    (add-to-list 'org-capture-templates
                 '("b"
                   "Hugo blogpost"
                   entry
                   (file+olp abram/blog-content-org-file "posts")
                   (function abram/org-hugo-new-subtree-post-capture-template)
                   :empty-lines 1)))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :after evil
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

(use-package hydra)

(general-define-key
  :keymaps 'lsp-mode-map
  :prefix lsp-keymap-prefix
  "d" '(dap-hydra t :wk "debugger"))

(add-hook 
  'prog-mode-hook
  (lambda ()
    (evil-local-set-key 'normal (kbd "mb") 'dap-breakpoint-toggle)))

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

(evil-global-set-key 'normal (kbd ",v") 'abram/switch-to-most-recent-buffer)

(evil-global-set-key 'normal (kbd ",b") 'previous-buffer)
(evil-global-set-key 'normal (kbd ",f") 'next-buffer)

(evil-collection-define-key 'normal 'dired-mode-map
  "h" 'dired-single-up-directory
  "l" 'dired-single-buffer
  "H" 'dired-hide-dotfiles-mode)

(evil-collection-define-key 'normal 'dired-sidebar-mode-map
  "h" 'dired-sidebar-up-directory
  "l" 'dired-sidebar-find-file)

(evil-global-set-key 'normal (kbd ",w") 'evil-write)

(evil-global-set-key 'normal (kbd "=") 'evil-toggle-fold)

(evil-global-set-key 'normal (kbd "C-p") 'counsel-fzf)

(abram/leader-keys-map
  "f" 'counsel-projectile-rg)

(add-hook 'prog-mode-hook
          (lambda ()
            (evil-local-set-key 'normal (kbd ",a") 'projectile-toggle-between-implementation-and-test)
            (evil-ex-define-cmd "A" 'projectile-toggle-between-implementation-and-test)
            (evil-ex-define-cmd "AV" 'projectile-find-implementation-or-test-other-window)))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
