(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(ecb-options-version "2.40")
 '(inhibit-startup-screen t)
 '(org-directory "/home/apurba/wip" t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.lareful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;Added by Apurba
(setq default-frame-alist
      '((width . 120) (height . 80)
        (cursor-color . "black")
        (cursor-type . box)
        (foreground-color . "black")
        (background-color . "white")))


(setq inhibit-startup-message   t)   ; Don't want any startup message
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving

(setq search-highlight           t) ; Highlight search object
(setq query-replace-highlight    t) ; Highlight query object
(setq mouse-sel-retain-highlight t) ; Keep mouse high-lightening
(setq font-use-system-font t)       ;trying the system font

;; (global-set-key (kbd "C-z") 'undo)

(defvar LIMIT 1)
(defvar time 0)
(defvar mylist nil)

(defun time-now ()
   (car (cdr (current-time))))

;;list buffers
(defun bubble-buffer ()
   (interactive)
   (if (or (> (- (time-now) time) LIMIT) (null mylist))
       (progn (setq mylist (copy-alist (buffer-list)))
          (delq (get-buffer " *Minibuf-0*") mylist)
          (delq (get-buffer " *Minibuf-1*") mylist)))
   (bury-buffer (car mylist))
   (setq mylist (cdr mylist))
   (setq newtop (car mylist))
   (switch-to-buffer (car mylist))
   (setq rest (cdr (copy-alist mylist)))
   (while rest
     (bury-buffer (car rest))
     (setq rest (cdr rest)))
   (setq time (time-now)))

(defun geosoft-kill-buffer ()
   ;; Kill default buffer without the extra emacs questions
   (interactive)
   (kill-buffer (buffer-name))
   (set-name))

(global-set-key [C-delete] 'geosoft-kill-buffer) 

;;key for going to line
(global-set-key "\C-l" 'goto-line) ; [Ctrl]-[L] 

;; makes the tool bar disappear
(tool-bar-mode 0)

;; Added to make indent 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default tab-stop-list (number-sequence 4 200 4))

(setq indent-line-function 'insert-tab)


;; Added to remove the menu bar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; make emacs use the clipboard
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)


;;enable kill all direds
(defun kill-all-dired()
 (dolist(buffer (buffer-list))
             (set-buffer buffer)
             (when (equal major-mode 'dired-mode)
               (kill-buffer buffer)
             )
 )
)

;; Get the current filename
(defun show-current-filename()
  "Shows the current filename from buffer-file-truename added by AN"
  (interactive)
  (message "Filename is %s" buffer-file-truename)
)

(global-set-key "\M-\r" 'show-current-filename) 

;; added for the nasty autosave and bakcup litter
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; Reload file
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) 
  (revert-buffer t t)
  ;; (ecb-rebuild-methods-buffer)
)
(global-set-key [f5] 'revert-buffer-no-confirm) 

(add-to-list 'load-path "/data/apps/emcust")
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)

;; delete line no kill
(defun delete-line()
  (interactive)
  (delete-region (line-beginning-position) (line-end-position))
)
(global-set-key [C-S-delete] 'delete-line)

;; unbound c-/ from undo and bind it to comment-region
(global-unset-key (kbd "C-/"))

(global-set-key (kbd "C-/") 'comment-or-uncomment-region)

;; unbound c-t and bind it to eclipse like find type
;; (global-unset-key (kbd "C-t"))
;;(global-set-key (kbd "C-t") 'find-name-dired)
(setq project-directory "/home/apurba/wip")

(defun custom-find-name-dired (pattern)
  "Open from specific dir"
  (interactive "s Pattern: ")
  ;;(message "directory is : %s " project-directory)
  (find-name-dired default-directory pattern)
)
(global-set-key (kbd "C-S-r") 'custom-find-name-dired)

;; goto last edited http://emacsworld.blogspot.com/2010/04/remembering-last-edited-location-in.html
(defun goto-last-edit-point ()
"Go to the last point where editing occurred."
(interactive)
(let ((undos buffer-undo-list))
(when (listp undos)
(while (and undos
(let ((pos (or (cdr-safe (car undos))
(car undos))))
(not (and (integerp pos)
(goto-char (abs pos))))))
(setq undos (cdr undos))))))

(global-set-key (kbd "C-q") 'goto-last-edit-point) 

;; Added for org mode
(add-to-list 'auto-mode-alist '("\\.aporg\\'" . org-mode))
(global-set-key "\C-ca" 'org-agenda)
(setq org-log-done 'time)
(setq org-directory "/home/apurba/wip")
(setq org-default-notes-file (concat org-directory "/Plan.aporg"))
(global-set-key "\C-cc" 'org-capture)
(setq org-agenda-files (concat org-directory "/agendafiles"))

;; Faster window switching
(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

;; c-delete closes current file
;; Activating delete selection mode so delete would delete regions
(delete-selection-mode 1)
;; Start in full screen mode
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)

(toggle-fullscreen)

;; Quicker way to get around perspective issues
(global-set-key [f8] 'frame-configuration-to-register)
(global-set-key [f9] 'jump-to-register)


(global-set-key [f6] 'ecb-minor-mode)

(ido-mode 1)                            ; ido mode with
(setq ido-enable-flex-matching t)       ; fuzzy completion

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;;##########################################
;; needs cedet, ecb
;; AN added CEDET support
;;(load-file  "/host/apurba/downloads/tools/cedet-1.0/common/cedet.el")

;; AN experimenting with EDE
;;(add-to-list 'load-path "/host/apurba/downloads/tools/ecb-2.40")
;;(load-file "/host/apurba/downloads/tools/ecb-2.40/ecb.el")

;;(require 'ecb)

(setq ecb-tip-of-the-day nil)
(global-set-key "\C-o" 'ecb-goto-window-methods) 

;;##########################################
;;  needs jtags
;; AN experimenting with java support
;;(load-file "/host/apurba/downloads/tools/jtags.el")
;;(autoload 'jtags-mode "jtags" "Toggle jtags mode." t)
;;(add-hook 'java-mode-hook 'jtags-mode)
;;(setq tags-revert-without-query 't)

;; AN adding class search
;;(defun custom-find-java-class(pattern) 
;;    "Open class file"
;;    (interactive "s className ")
    ;; (find-tag-regexp (concat "class " pattern))
;;    (find-tag-regexp (concat "\\(class\\|interface\\) " pattern))
;;)
;;(global-set-key (kbd "C-S-t") 'custom-find-java-class)


;;##########################################
;; added clojure support
;;(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))
;;(autoload 'clojure-mode "clojure" nil t)
;;(require 'clojure-mode)

;;(require 'mercurial)

;; not working since 12.04
;;(dir-locals-mode 1)

;;##########################################
;; etags
;; AN: commented out as working only on mysql code
;; (setq tags-table-list '("/host/apurba/downloads/tools/java"
;;                         "/host/apurba/thirdPartyLibs/hadoop/src"
;;                         "/host/apurba/thirdPartySrc/linux/mysql/sql"
;;                         "/host/apurba/thirdPartySrc/linux/dtrace-git/linux"
;; ))
;; (setq tags-table-list '( "/data/host/apurba/langexp/js/v8/src/" ))
;;(setq tags-table-list '( "/host/apurba/thirdPartySrc/linux/mysql/"))
;; (setq tags-table-list '( "/host/projects/ss-git/disrupretail/tools/opencv"))
;;(setq tags-table-list '( "/host/apurba/thirdPartySrc/linux/dtrace-git/linux"))
;; (setq tags-table-list '( "/data/host/projects/adap.tv/ribs2/wip/"))

;;##########################################
;; Adding slime support AN 14th Feb
;;##########################################
;;(setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
;;(add-to-list 'load-path "/host/apurba/langexp/lisp/slime/")  ; your SLIME directory
(require 'slime)
(slime-setup)





;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
;; Added 28th March for multiple cursors from marmalade
(require 'multiple-cursors)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-to-list 'auto-mode-alist '("\\.groovy\\'" . java-mode))

;; AN: 5th November 2013, experimenting with Prolog
;; (autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
;; (autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
;; (autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
;; (setq prolog-system 'swi)
;; (setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
;;                                 ("\\.m$" . mercury-mode))
;;                               auto-mode-alist))


;; AN removed markdown promotion keys
(add-hook 'markdown-mode-hook 'bind-windmove-keys)
;;(eval-after-load "markdown-mode-hook" disable-promotion-keys)
(defun bind-windmove-keys()
  (local-set-key [M-left] 'windmove-left)
  (local-set-key [M-right] 'windmove-right)
  (local-set-key [M-up] 'windmove-up)
  (local-set-key [M-down] 'windmove-down)
)

;; AN adding support for skewer https://github.com/skeeto/skewer-mode
(skewer-setup)


;; AN java debugging crap
;; (add-to-list 'load-path (expand-file-name "/data/apps/emcust/jdibug-0.5"))
;; (require 'jdibug)


(setq initial-scratch-message ";;use c-j to evaluate\n(setq project-directory \"/data/work/projects/orchestrator/wip/\")\n(setq tags-table-list '( \"/data/work/ss-git/fun/pic2perfect/sandbox/tesseract-ocr/\")) \n;;use c-x z to repeat commands")

;; AN added to override all other key settings http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map [M-left] 'windmove-left)
(define-key my-keys-minor-mode-map [M-right] 'windmove-right)
(define-key my-keys-minor-mode-map [M-up] 'windmove-up)
(define-key my-keys-minor-mode-map [M-down] 'windmove-down)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

(setenv "NODE_NO_READLINE" "1")


;; Added by AN remove all newlines
(defun unwrap-line ()
  "Remove all newlines until we get to two consecutive ones.
    Or until we reach the end of the buffer.
    Great for unwrapping quotes before sending them on IRC."
  (interactive)
  (let ((start (point))
        (end (copy-marker (or (search-forward "\n\n" nil t)
                              (point-max))))
        (fill-column (point-max)))
    (fill-region start end)
    (goto-char end)
    (newline)
    (goto-char start)))


;; needs external packages
;; AN problems with ecb
(setq ecb-examples-bufferinfo-buffer-name nil)

;; AN added ess support (R)
(require 'ess-site)


