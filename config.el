;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "M+ 1mn" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/Org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Don't continue commented lines with o/O
(setq +evil-want-o/O-to-continue-comments nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;

;; Having some issues with +default--delete-backward-char-a at the moment so remove it
(advice-remove #'delete-backward-char #'+default--delete-backward-char-a)

(defun ap-smartparens-change-line ()
  "Kill sexp and then enter insert state."
  (interactive)
  (sp-kill-hybrid-sexp nil)
  (evil-insert-state))

(defun ap-indent-defun ()
  "Indent current lisp function."
  (interactive)
  (let ((l (save-excursion (beginning-of-defun 1) (point)))
        (r (save-excursion (end-of-defun 1) (point))))
    (indent-region l r)))

(map! :mode (emacs-lisp-mode clojure-mode clojurescript-mode)
      :n "D" #'sp-kill-hybrid-sexp
      :n "C" #'ap-smartparens-change-line
      (:leader
       (:prefix ("l" . "sexp manipulation")
        :desc "Indent function" "i" #'ap-indent-defun
        :desc "Raise sexp"      "r" #'sp-raise-sexp
        :desc "Forward slurp"   "." #'sp-forward-slurp-sexp
        :desc "Forward barf"    "," #'sp-forward-barf-sexp)))

;; Unbind the default C-x C-s (company-yasnippet) on insert mode
(map! (:prefix "C-x" :i "C-s" nil))

;; Load local machine configuration from config.local.el
(let ((local-config-file (expand-file-name "config.local.el" doom-private-dir)))
  (when (file-exists-p local-config-file)
    (load local-config-file)))
