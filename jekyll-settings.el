;; Inspired by https://github.com/wdenton/.emacs.d/blob/master/setup/setup-jekyll.el
;; 

(defvar jekyll-directory "~/Devel/ic3guy.github.io/" "Path to Jekyll blog. Must end in /")
(defvar jekyll-drafts-dir "_drafts/" "Relative path to drafts directory.")
(defvar jekyll-posts-dir "_posts/" "Relative path to posts directory.")
;;(defvar jekyll-post-ext ".md"  "File extension of Jekyll posts.")
;;(defvar jekyll-post-template "#+BEGIN_HTML\n---\nlayout: post\ntitle: %s\ntags:\ndate: \n---\n#+END_HTML\n" "Default template for Jekyll posts. %s will be replace by the post title.")

;; (defvar jekyll-post-template "#+SEQ_TODO: DRAFT | DONE\n* %s")
(defvar jekyll-post-template "#+TODO: DRAFT PUBLISH\n#+STARTUP: logdone\n* %s")

(defvar jekyll-post-ext ".org"  "File extension of Jekyll posts.")

;; (setq org-todo-keywords
;;            '((sequence "TODO" "|" "DONE")
;;              (sequence "DRAFT" "|" "PUBLISH")))

(setq org-todo-keyword-faces '(("PUBLISH" . (:background "green" :foreground "black" :weight bold))))

;; (setq org-log-done 'time)		

(defun jekyll-yaml-escape (s) "Escape a string for YAML."
       (if (or (string-match ":" s) (string-match "\"" s)) (concat "\"" (replace-regexp-in-string "\"" "\\\\\"" s) "\"") s))

(defun jekyll-make-slug (s) "Turn a string into a slug."
  (replace-regexp-in-string " " "-"  (downcase (replace-regexp-in-string "[^A-Za-z0-9 ]" "" s))))

(defun jekyll-draft-post (title) "Create a new Jekyll blog post."
  (interactive "sPost Title: ")
  (let ((draft-file (concat jekyll-directory jekyll-drafts-dir
                            (jekyll-make-slug title)
                            jekyll-post-ext)))
    (if (file-exists-p draft-file)
        (find-file draft-file)
      (find-file draft-file)
      (insert (format jekyll-post-template title))
      (org-mode-restart)
      (org-todo "DRAFT"))))
 
;;      (org-set-property "EXPORT_FILE_NAME" (jekyll-make-slug title)))))

(add-hook 'org-trigger-hook 'org-potion-publish-name)

(defun org-potion-publish-name (vals)
  (message (plist-get vals :from)))


(provide 'jekyll-settings)
