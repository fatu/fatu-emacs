;; global
(add-hook 'ess-mode-hook
           (lambda ()
             (ess-set-style 'GNU 'quiet)))
;; line number and format
(global-linum-mode 1)
(setq linum-format "%d| ")

(setq make-backup-files nil) ; won't gen '~' backup file

;; custom-set-variables
(custom-set-variables
'(show-paren-mode t))


;;; package 

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)
(load-theme 'zenburn t)

;; X window default
;;(defun toggle-fullscreen ()
;;  (interactive)
;;  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;;			  '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
;;  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
;;			  '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
;;)
;;(toggle-fullscreen)


;;(require 'desktop)
;;  (desktop-save-mode 1)
;;  (defun my-desktop-save ()
;;    (interactive)
;;    ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
;;    (if (eq (desktop-owner) (emacs-pid))
;;        (desktop-save desktop-dirname)))
;;  (add-hook 'auto-save-hook 'my-desktop-save)

;; ido-mode
(require 'ido)
(ido-mode t)

;; shell color
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; el-get
;;(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;;(unless (require 'el-get nil 'noerror)
;;  (with-current-buffer
;;      (url-retrieve-synchronously
;;       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;;    (let (el-get-master-branch)
;;      (goto-char (point-max))
;;      (eval-print-last-sexp))))
;;(el-get 'sync)

;; install jedi
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)

;; flycheck
(add-hook 'after-init-hook 'global-flycheck-mode)

;; autopair
;; (setq autopair-extra-pairs '(:everywhere ((?< . ?>))))

(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;; python-mode-hook
;;(add-hook 'python-mode-hook guess-style-guess-tabs-mode)
;;(add-hook 'python-mode-hook (lambda ()
;;                               (when indent-tabs-mode
;;                                 (guess-style-guess-tab-width))))


;;; ESS
 (add-hook 'ess-mode-hook
           (lambda ()
             (ess-set-style 'GNU 'quiet)
             ;; Because
             ;;                                 DEF GNU BSD K&R  C++
             ;; ess-indent-level                  2   2   8   5  4
             ;; ess-continued-statement-offset    2   2   8   5  4
             ;; ess-brace-offset                  0   0  -8  -5 -4
             ;; ess-arg-function-offset           2   4   0   0  0
             ;; ess-expression-offset             4   2   8   5  4
             ;; ess-else-offset                   0   0   0   0  0
             ;; ess-close-brace-offset            0   0   0   0  0
             (add-hook 'local-write-file-hooks
                       (lambda ()
                         (ess-nuke-trailing-whitespace)))))
 (setq ess-nuke-trailing-whitespace-p 'ask)
 ;; or even
 ;; (setq ess-nuke-trailing-whitespace-p t)
