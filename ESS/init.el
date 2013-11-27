;; Paul Johnson
;; 2013-09-30

;; Workaround for shift-enter trouble on Windows

;; UPDATE: Because Emacs ESS changes made this MUCH easier, my
;; re-work gets shorter :=)


;; INSTRUCTIONS. Put this file in ~/.emacs, or in ~/emacs.d/init.el,
;; or in the Emacs site-start.d folder.

;; R USER PREVIEW.
;; Here are my special features related to ESS with R.

;; 1. Indentation policy follows Programming R Extensions Manual
;; UPDATE 2013-07-10. No longer needed. This is ESS default as of version 13-05

;; 2. Shift+Enter will send the current line to R, and it will start R
;; if it is not running.  ESS 13-05 chose instead CTL+Enter, which I
;; DO NOT want because it conflicts with CUA mode.

;; 3. R will assume the current working directory is the document directory.

;; 4. R runs in its own "frame"

;; 5. Emacs help pops up in its own frame.


;; JUSTIFICATION.  The intention is to make Emacs work more like a
;; "modern" GUI editor.
;; See my companion lecture
;; "Emacs Has No Learning Curve"
;; http://pj.freefaculty.org/guides/Rcourse


;; Paul Johnson <pauljohn@ku.edu>
;; 2012-11-24
;;
;; Conflicts between Emacs-ESS and SAS usage forced me to make
;; some changes. And for no benefit, as SAS mode still not great.
;; I had to cut out a lot of framepop stuff.
;;


;; 2013-07-10 TODO: Find out if this is still necessary, or for
;; which versions of windows.

;; Section I. Windows OS work-arounds

(if (eq system-type 'windows-nt)
    (setq use-file-dialog nil))
;; There's been a chronic problem with file selection dialogs on Windows
;; Maybe you commment previous out and see if your Windows is fixed.



;; Section II. Keyboard and mouse customization

;; IIA: make mouse selection work in the usual Mac/Windows way

;; 2013-07-10 Comment these out
;; (setq shift-select-mode t) ; is default in Emacs 23+, replaces pc-select
;; (transient-mark-mode t) ; highlight text selection, is default Emacs 23+
(delete-selection-mode t) ; delete seleted text when typing


;; http://ergoemacs.org/emacs/emacs24_features.html
;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
;; (setq x-select-enable-clipboard t)

;; after mouse selection in X11, you can paste by `yank' in emacs
;;(setq x-select-enable-primary t)
;; This seems not reliable to me (2013-07-10)

;; TODO:
;; Figure out Emacs-24 trouble with mouse selections. I need to
;; figure out where the truth lies

;; In Linux, I see weirdness in Emacs 24 with paste and clipboard. Confusing!
;; http://stackoverflow.com/questions/13036155/how-to-to-combine-emacs-primary-clipboard-copy-and-paste-behavior-on-ms-windows
(setq select-active-regions t)
(global-set-key [mouse-2] 'mouse-yank-primary)  ; make mouse middle-click only paste from primary X11 selection, not clipboard and kill ring.

;;(setq mouse-drag-copy-region t)
;; See following http://emacswiki.org/emacs/CopyAndPaste
;; where there is a ton of really confusing advice.

;; highlight does not alter KILL ring
(setq mouse-drag-copy-region nil)


;; IIB: keyboard customization

;; CUA mode is helpful not only for copy and paste, but also C-Enter is rectangle select
(cua-mode t) ; windows style binding C-x, C-v, C-c, C-z
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
;;20130717(setq cua-keep-region-after-copy t) ;; Selection remains after C-c

;; write line numbers on left of window
;; Caution: if you do this, it makes Emacs much slower!
;;(global-linum-mode 1) ; always show line numbers


;; Section III. Programming conveniences:
(show-paren-mode t) ; light-up matching parens
(global-font-lock-mode t) ; turn on syntax highlighting
(setq text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))



;; Section IV. ESS Emacs Statistics

;; start R in current working directory, don't let R ask user
(setq ess-ask-for-ess-directory nil)

;; ESS 13.05 default C-Ret conflicts with CUA mode rectangular selection.
;; Change shortcut to use Shift-Return
;; Suggested by Vitalie Spinu ESS-help email 2013-05-15
;; worked in Linux, not Windows 2013-09-29
;;(define-key ess-mode-map [(control return)] nil)
;;(define-key ess-mode-map [(shift return)] 'ess-eval-region-or-line-and-step)

;; cause "Shift+Enter" to send the current line to *R*
(defun my-ess-eval ()
  (interactive)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))

(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))



;; create a new frame for each help instance
;; (setq ess-help-own-frame t)
;; If you want all help buffers to go into one frame do:
(setq ess-help-own-frame 'one)

;; I want the *R* process in its own frame
;; This was a broken feature in ESS, fixed now. Helps massively!
(setq inferior-ess-own-frame t)
;;(setq inferior-ess-same-window nil)

;; See no beauty in this. Test: move pointer into a function
;; Run C-c C-d C-e to see effect
;;(setq ess-describe-at-point-method 'tooltip)

;; PJ 2013-07-10 Following commented out
;; PJ 2012-03-21 because ESS 13.05 made it default
;; Indentation per Programming R Extensions
;; (add-hook 'ess-mode-hook
;;    (lambda ()
;;    (ess-set-style 'C++ 'quiet)
;;    (add-hook 'local-write-file-hooks
;;	      (lambda ()
;;		(ess-nuke-trailing-whitespace)))))
;;;;(setq ess-nuke-trailing-whitespace-p 'ask)
;;;; or even
;;(setq ess-nuke-trailing-whitespace-p t)
;;; Perl
;;(add-hook 'perl-mode-hook
;;	  (lambda () (setq perl-indent-level 4)))
;; End ESS


;; In Spring 2012, we noticed ESS SAS mode doesn't work well
;; at all on Windows, that lead to removal of lots of stuff
;; I really liked. Even then, we couldn't get much satisfaction.
;;
;; Following was needed for that, otherwise, it is not needed
;; (load "ess-site")
;; (ess-sas-global-unix-keys)


;; PJ 2013-02-28
;; stops suggestions in R when tabbing. Quiets noise, but ruins feature
;; (setq completion-auto-help nil)



;; ;; ;; Section V. Customize the use of Frames. Try to make new content
;; ;; ;; appear in wholly new frames on screen.
;; ;; ;;
;; ;; ;; V.A: Discourage Emacs from splitting "frames", encourage it to pop up new
;; ;; ;; frames for new content.
;; ;; ;; see: http://www.gnu.org/software/emacs/elisp/html_node/Choosing-Window.html
;; (setq pop-up-frames t)
;; (setq special-display-popup-frame t)
(setq split-window-preferred-function nil) ;discourage horizontal splits
;; (setq pop-up-windows nil)


;; V.C: Make files opened from the menu bar appear in their own
;; frames. This overrides the default menu bar settings.  Opening an
;; existing file and creating new one in a new frame are the exact
;; same operations.  adapted from Emacs menu-bar.el
(defun menu-find-existing ()
  "Edit the existing file FILENAME."
  (interactive)
  (let* ((mustmatch (not (and (fboundp 'x-uses-old-gtk-dialog)
                              (x-uses-old-gtk-dialog))))
         (filename (car (find-file-read-args "Find file: " mustmatch))))
    (if mustmatch
        (find-file-other-frame filename)
      (find-file filename))))
(define-key menu-bar-file-menu [new-file]
  '(menu-item "Open/Create" find-file-other-frame
	      :enable (menu-bar-non-minibuffer-window-p)
	      :help "Create a new file"))
(define-key menu-bar-file-menu [open-file]
  '(menu-item ,(purecopy "Open File...") menu-find-existing
              :enable (menu-bar-non-minibuffer-window-p)
              :help ,(purecopy "Read an existing file into an Emacs buffer")))


;; V.D  Open directory list in new frame.
(define-key menu-bar-file-menu [dired]
  '(menu-item "Open Directory..." dired-other-frame
	      :help "Read a directory; operate on its files (Dired)"
	      :enable (not (window-minibuffer-p (frame-selected-window menu-updating-frame)))))




;; Section VI: Miscellaneous convenience

;; Remove Emacs "splash screen"
;; http://fuhm.livejournal.com/
(defadvice command-line-normalize-file-name
  (before kill-stupid-startup-screen activate)
  (setq inhibit-startup-screen t))
(setq inhibit-splash-screen t)


;; Show file name in title bar
;; http://www.thetechrepo.com/main-articles/549
(setq frame-title-format "%b - Emacs")


;; I'm right handed, need scroll bar on right (like other programs)
;;(setq scroll-bar-mode-explicit t)
;;(set-scroll-bar-mode `right)


;; Make Emacs scroll smoothly with down arrow key.
;; 2011-10-14
;; faq 5.45 http://www.gnu.org/s/emacs/emacs-faq.html#Modifying-pull_002ddown-menus
(setq scroll-conservatively most-positive-fixnum)


;; adjust the size of the frames, uncomment this, adjust values
;;(setq default-frame-alist '((width . 90) (height . 65)))


;; Remember password when connected to remote sites via Tramp
;; http://stackoverflow.com/questions/840279/passwords-in-emacs-tramp-mode-editing
;; Emacs "tramp" service (ssh connection) constantly
;; asks for the log in password without this
(setq password-cache-expiry nil)


;; Section : Emacs shells work better
;; http://snarfed.org/why_i_run_shells_inside_emacs
(setq ansi-color-for-comint-mode 'filter)
(setq comint-prompt-read-only t)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)


