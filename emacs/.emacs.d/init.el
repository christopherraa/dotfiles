;;; init.el --- Initialization file for Emacs
;;;
;;; Commentary:
;; Emacs Startup File --- initialization for Emacs

;;; Code:

;; Make the interface a bit cleaner by removing the startup message and removing toolbar ad menubar
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Read custom settings from custom.el in the emacs directory if such a file exist.
;; I don't really use it though.
(defvar custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Read any private settings from my private.el file. This will not be in git.
(defvar private-file (expand-file-name "private.el" user-emacs-directory))
(when (file-exists-p private-file)
	(load private-file))


;; Define and initialise package repositories. Primarily using Melpa, but more will
;; be added when needed.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Use use-package to simplify the installation and initialization of packages I use
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
;; Makes it so I don't have to add an `:ensure` tag to all use-package blocks
(setq use-package-always-ensure 't)

;; Line numbers are nifty, but you might not want this in all modes / buffers (like eshell)
(global-display-line-numbers-mode 1)

;; Seeing matching parens in lisp (especially) is paramount
(show-paren-mode 1)

;; Enable the exotica theme, as that is quite pleasant to use
(use-package exotica-theme
  :config (load-theme 'exotica t))

;; Org-mode is basically an essential part of my kit and day-to-day work. The config is
;; somewhat large, but the productivity gains are amazing.
(use-package org
  :commands (org-capture org-agenda)
	:custom
  (org-agenda-start-with-log-mode t)
  ;; Configure custom agenda views
  (org-agenda-custom-commands
	 ;; Dashboard view is quite nice, giving me my agenda for the day, active tasks I am
	 ;; working on plus a list of the tasks I have marked as my next tasks
   '(("d" "Dashboard"
			((agenda "" ((org-deadline-warning-days 7)))
       (todo "ACTIVE"
						 ((org-agenda-overriding-header "Active Tasks")))
       (todo "NEXT"
						 ((org-agenda-overriding-header "Next Tasks")))
       ))

		 ;; Simply shows a list of any active tasks.
     ("n" "Active Tasks"
			((todo "ACTIVE"
						 ((org-agenda-overriding-header "Next Tasks")))))

		 ;; Similarly shows me a list of all my next tasks
     ("n" "Next Tasks"
			((todo "NEXT"
						 ((org-agenda-overriding-header "Next Tasks")))))

		 ;; All tasks tagged as being related to work. I don't really use this though.
     ("W" "Work Tasks" tags-todo "+work-email")))

	;; Capturing tasks, journal entries etc is super useful, and this setup allows for that from whereever
  (org-capture-templates
   `(("t" "Tasks / Projects")
		 ;; Capturing a todo-item is super simple. Add some extra information in the entry, such as
		 ;; where the todo was captured from. Useful for making notes to get back to some piece of
		 ;; code or whatnot.
     ("tt" "Task" entry (file+olp org-todo-file "Inbox")
      "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

		 ;; Capturing journal entries is something I mostly use for note-taking
     ("j" "Journal Entries")
     ("jj" "Journal" entry
      (file+olp+datetree org-journal-file)
      "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
      :clock-in :clock-resume
      :empty-lines 1)
     ("jm" "Meeting" entry
      (file+olp+datetree org-journal-file)
      "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
      :clock-in :clock-resume
      :empty-lines 1)

		 ;; Used to use this for email-handling as part of Org, but don't really do that any more.
     ("w" "Workflows")
     ("we" "Checking Email" entry (file+olp+datetree org-todo-file)
      "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)))

  :config
	;; Making org-mode just a little bit pretties
  (setq org-ellipsis " ▾")

	;; Add timer to logging items. Might be useful some day.
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

	;; Set files that are read as part of the agenda views
  (setq org-agenda-files '(org-todo-file org-archive-file))

	;; I use these states for all my tasks. So those four states represent a tasks normal progression.
  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "ACTIVE(a)" "|" "DONE(d!)")))

	;; Lets me conveniently choose which file to refile tasks to, eg after thery have been done,
	;; plus to which section in those files they should be refiled.
  (setq org-refile-targets
    '(("todo-archive.org" :maxlevel . 1)
      ("todo.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling. Considering saving all buffers on _any_ changes, but that can
	;; be added later.
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

	;; Some tags that can be useful to quick-select
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

	;; Bing a convenient combo for capturing tasks
  (define-key global-map (kbd "C-c t")
    (lambda () (interactive) (org-capture nil "tt"))))

;; YAML is used all the time, so make sure that is available
(use-package yaml-mode)

;; Can you code and not use magit? Didn't this so.
(use-package magit
	:config
	(global-set-key (kbd "C-c g") 'magit-status))

;; Git gitter is useful to see which lines have been changed in a tracked file.
(use-package git-gutter+)
(global-git-gutter+-mode)
(setq git-gutter+-separator-sign "│")
(set-face-foreground 'git-gutter+-separator "#5f5f5f")
(setq git-gutter+-hide-gutter t)

;; Indentation. Many discussions have been had about this topic. I, unlike the fanatics on
;; either side of the TABS / SPACES divide, have settled on the unquestionably correct take
;; that tabs should be used for indentation, and spaces should be used for alignment. This
;; is the only way everyone can have apleasant experience editing code since this allows
;; people to set their preferred _visual_ indentation width to whatever makes it easiest
;; for them to read the code.
(setq-default indent-tabs-mode t)
;; I prefer 2 char visual indentation, but I think most people like 4

;; Make sure cperl-mode is used instead of perl-mode
(setq-default tab-width 2)
(fset 'perl-mode 'cperl-mode)
(use-package cperl-mode
	:custom
	(cperl-invalid-face nil)
	(cperl-indent-level 2)
	(cperl-tab-always-indent t)
	(cperl-indent-parens-as-block t)
	(cperl-close-paren-offset (- cperl-indent-level)))
(use-package cpanfile-mode)


;; These overrides are here because I use emacs through tmux, with $TERM
;; set to screen-256color, and without these mappings the input would not
;; map to the correct windmove-function.
(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[1;2B" [S-down])
(define-key input-decode-map "\e[1;2C" [S-right])
(define-key input-decode-map "\e[1;2D" [S-left])
;; Use Shift+arrow_keys to move cursor around split panes
(windmove-default-keybindings)

;; When cursor is on edge, move to the other side, as in a torus space
(setq windmove-wrap-around t)

;; Editing a lot of dockerfiles, so make sure I have a mode for that
(use-package dockerfile-mode)

;; Markdown is used every day, so get a mode for that as well
(use-package markdown-mode)


;; Prefer ivy + counsel for a completion framework setup
(use-package ivy
	:diminish
	:bind (("C-s" . swiper))
	:config
	(setq ivy-use-virtual-buffers t)
	(setq ivy-extra-directories nil)
	(ivy-mode 1))
(use-package counsel
	:diminish
	:config
	(counsel-mode 1))

;; ivy-rich provides more context information in the selection lists such as
;; descriptions for functions etc
(use-package ivy-rich
	:config
	(ivy-rich-mode 1)
	(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

;; Make sure backup files do not clutter working directories
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

;; Pretty parenthesis are pretty.
(use-package rainbow-delimiters
	:init (rainbow-delimiters-mode 1))

;; Syntax checking and highlighting of errors or code-smells
(use-package flycheck
	:init
	(setq flycheck-check-syntax-automatically '(save))
	(global-flycheck-mode))

;; Code completion using company
(use-package company
	:hook prog-mode)

;;; init.el ends here
