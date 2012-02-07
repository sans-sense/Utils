(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(ecb-options-version "2.40")
 '(inhibit-startup-screen t)
 '(org-directory "/home/apurba/wip" t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
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
;        (font . "-*-Courier-normal-r-*-*-13-*-*-*-c-*-iso8859-1")))

;(setq initial-frame-alist '((top . 10) (left . 30)))

(setq inhibit-startup-message   t)   ; Don't want any startup message
(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving

(setq search-highlight           t) ; Highlight search object
(setq query-replace-highlight    t) ; Highlight query object
(setq mouse-sel-retain-highlight t) ; Keep mouse high-lightening
(setq font-use-system-font t)       ;trying the system font

(global-set-key [f2] 'split-window-vertically) 
(global-set-key [f1] 'remove-split) 
(global-set-key (kbd "C-z") 'undo)

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

(global-set-key [f4] 'bubble-buffer) 


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
  (ecb-rebuild-methods-buffer)
)
(global-set-key [f5] 'revert-buffer-no-confirm) 

(add-to-list 'load-path "~/emcust/elisp")
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

(require 'mercurial)

;; Quicker way to get around perspective issues
(global-set-key [f8] 'frame-configuration-to-register)
(global-set-key [f9] 'jump-to-register)

(dir-locals-mode 1)

(setq tags-table-list '("/host/apurba/downloads/tools/java"
                        "/host/apurba/thirdPartyLibs/hadoop/src"
                        "/host/apurba/thirdPartySrc/linux/mysql-5.1/sql"
))

;; AN added CEDET support
(load-file  "/host/apurba/downloads/tools/cedet-1.0/common/cedet.el")

;; AN experimenting with EDE
(add-to-list 'load-path "/host/apurba/downloads/tools/ecb-2.40")
(load-file "/host/apurba/downloads/tools/ecb-2.40/ecb.el")

(require 'ecb)
(setq ecb-tip-of-the-day nil)

;; AN experimenting with java support
(load-file "/host/apurba/downloads/tools/jtags.el")
(autoload 'jtags-mode "jtags" "Toggle jtags mode." t)
(add-hook 'java-mode-hook 'jtags-mode)
(setq tags-revert-without-query 't)

(global-set-key "\C-o" 'ecb-goto-window-methods)

;; AN adding class search
(defun custom-find-java-class(pattern) 
    "Open class file"
    (interactive "s className ")
    ;; (find-tag-regexp (concat "class " pattern))
    (find-tag-regexp (concat "\\(class\\|interface\\) " pattern))

)
(global-set-key (kbd "C-S-t") 'custom-find-java-class)

(global-set-key [f6] 'ecb-minor-mode)

