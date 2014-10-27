;; Inspired by https://github.com/wdenton/.emacs.d/blob/master/setup/setup-jekyll.el
;; 

(defvar jekyll-directory "~/Devel/ic3guy.github.io/" "Path to Jekyll blog. Must end in /")
(defvar jekyll-drafts-dir "_drafts/" "Relative path to drafts directory.")
(defvar jekyll-posts-dir "_posts/" "Relative path to posts directory.")
;;(defvar jekyll-post-ext ".md"  "File extension of Jekyll posts.")
;;(defvar jekyll-post-template "#+BEGIN_HTML\n---\nlayout: post\ntitle: %s\ntags:\ndate: \n---\n#+END_HTML\n" "Default template for Jekyll posts. %s will be replace by the post title.")

;; (defvar jekyll-post-template "#+SEQ_TODO: DRAFT | DONE\n* %s")
(defvar jekyll-post-template
  "#+TODO: DRAFT PUBLISH
#+OPTIONS: toc:nil todo:nil
#+STARTUP: logdone
* %s")

(defvar jekyll-post-ext ".org"  "File extension of Jekyll posts.")

;; (setq org-todo-keywords
;;            '((sequence "TODO" "|" "DONE")
;;              (sequence "DRAFT" "|" "PUBLISH")))

(setq org-todo-keyword-faces '(("PUBLISH" . (:background "green" :foreground "black" :weight bold))))

;; (setq org-log-done 'time)		

(defun jekyll-yaml-escape (s) "Escape a string for YAML."
       (if (or (string-match ":" s) (string-match "\"" s)) (concat "\"" (replace-regexp-in-string "\"" "\\\\\"" s) "\"") s))

;; remove any non ascii ^ inside [] negates

(defun jekyll-make-slug (s) "Turn a string into a slug."
       (replace-regexp-in-string " " "-"  (downcase (replace-regexp-in-string "[^A-Za-z0-9 ]" "" s))))

(defun org-potion-create-vessel (title) "Create a new org file to hold draft blog posts."
  (interactive "sOrg File Title: ")
  (let ((draft-file (concat jekyll-directory jekyll-drafts-dir
                            (jekyll-make-slug title)
                            jekyll-post-ext)))
    (if (file-exists-p draft-file)
        (find-file draft-file)
      (find-file draft-file)
      (insert (format jekyll-post-template title))
      (org-mode-restart)
      (org-todo "DRAFT"))))

(add-hook 'org-trigger-hook 'org-potion-quaff)

(defun org-potion-post-header (title)
  (format "---\nlayout: post\ntitle: %s\n---\n" (jekyll-yaml-escape title)))

(defun org-potion-quaff (vals)
  (let* ((heading (nth 4 (org-heading-components)))
	 (file-path (concat jekyll-directory jekyll-posts-dir
				      (format-time-string "%Y-%m-%d-")
				      (jekyll-make-slug heading) ".md")))
    (when (string-equal (plist-get vals :to) "PUBLISH")
      (org-export-to-file 'md file-path nil t)
      (set-buffer (find-file-noselect file-path))
      (goto-char (point-min))
      (insert (org-potion-post-header heading))
      (save-buffer)
      (kill-buffer))))

(defun org-potion-bottle (heading)
  (interactive)
  (goto-char (point-min))
  (insert heading))

  ;; (print (plist-get vals :to))
  ;; (print (format-time-string "Today is %Y-%m-%d")))


(provide 'jekyll-settings)
