(when (>= emacs-major-version 24)
    (require 'package)
    (package-initialize)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))
(require 'cl)
(defvar my/packages '(
	       company
	       hungry-delete
	       swiper
               color-theme-sanityinc-tomorrow
	       dracula-theme
	       counsel
               spaceline
	       rainbow-delimiters
	       smex
	       magit
	       all-the-icons
	       diminish
	       yasnippet
               evil
	       smartparens
	       ) "Default packages")

(setq package-selected-packages my/packages)

(defun my/packages-installed-p ()
    (loop for pkg in my/packages
	  when (not (package-installed-p pkg)) do (return nil)
	  finally (return t)))

(unless (my/packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg my/packages)
      (when (not (package-installed-p pkg))
	(package-install pkg))))

(tool-bar-mode 0)
(menu-bar-mode 0)  
(scroll-bar-mode 0)
(global-linum-mode 1)
(setq inhibit-splash-screen 1)
(setq make-backup-files nil)
(delete-selection-mode 1)
(global-hl-line-mode 1)
(setq auto-save-default nil)
(setq make-backup-files nil)

(require 'color-theme-sanityinc-tomorrow)
(load-theme 'sanityinc-tomorrow-eighties 1)
;;(load-theme 'solarized-light 1)
;;(load-theme 'dracula t)
(require 'spaceline-config)
(spaceline-compile)
(setq powerline-default-separator 'nil)
(setq powerline-height 15)
(spaceline-spacemacs-theme)

(require 'diminish)
(diminish 'abbrev-mode "Abv")
(diminish 'yas-minor-mode "Y")

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(add-hook 'scheme-mode-hook 'smartparens-mode)
;;(add-hook 'inferior-scheme-mode-hook 'smartparens-mode)
(add-hook 'inferior-scheme-mode-hook (quote smartparens-mode))
(add-hook 'inferior-scheme-mode-hook (lambda () (linum-mode 0)))

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
;;(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

(require 'company)
(global-company-mode 1)
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
    (backward-char 1)
    (if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (cond
   ((minibufferp)
    (minibuffer-complete))
   (t
    (indent-for-tab-command)
    (if (or (not yas/minor-mode)
        (null (do-yas-expand)))
    (if (check-expansion)
        (progn
          (company-manual-begin)
          (if (null company-candidates)
          (progn
            (company-abort)
            (indent-for-tab-command)))))))))

(defun tab-complete-or-next-field ()
  (interactive)
  (if (or (not yas/minor-mode)
      (null (do-yas-expand)))
      (if company-candidates
      (company-complete-selection)
    (if (check-expansion)
      (progn
        (company-manual-begin)
        (if (null company-candidates)
        (progn
          (company-abort)
          (yas-next-field))))
      (yas-next-field))))) 
(defun expand-snippet-or-complete-selection ()
  (interactive)
  (if (or (not yas/minor-mode)
      (null (do-yas-expand))
      (company-abort))
      (company-complete-selection)))

(defun abort-company-or-yas ()
  (interactive)
  (if (null company-candidates)
      (yas-abort-snippet)
    (company-abort)))

(global-set-key (kbd "TAB") 'tab-indent-or-complete)
(define-key company-active-map (kbd "TAB") 'expand-snippet-or-complete-selection)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-keymap (kbd "TAB") 'tab-complete-or-next-field)
(define-key yas-keymap (kbd "C-g") 'abort-company-or-yas)

(defun file-run-scheme()
  (interactive)
  (progn
    (write-file (buffer-file-name))
    (setq current-file-name buffer-file-name)
    (switch-to-buffer-other-frame "*scheme*")
    (call-interactively 'run-scheme)
    (end-of-buffer)
    (insert "(load \""current-file-name"\")")))
(global-set-key (kbd "<f5>") (quote file-run-scheme))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 98 :width normal)))))
;;(set-face-attribute 'mode-line nil  :height 80)
(set-face-attribute 'mode-line nil :font "DejaVu Sans Condensed-9")
;;(add-hook 'after-init-hook
;;          '(lambda ()
;;             (load "~/.emacs.d/my-modeline.el")))
;;(setq-default mode-line-format nil)
;;(setq-default header-line-format 1)
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
