;;; side-toggle.el --- blah blah
;;; Package-Requires: ((dash "2.17.0"))

;;; Commentary:
;;; wibble wibble

;;; Code:

;;; -*- lexical-binding t; -*-




(defvar side-toggle--specs)
(setq side-toggle--specs
      '((term . ((tag . term)
                 (params . ((side . right)))
                 (get-buffer . (lambda () (get-buffer "*terminal*"))))
              )))

(side-toggle--set-spec 'term)

(side-toggle-toggle 'term)


(defvar side-toggle--spec)
(setq side-toggle--spec '())


;;;###autoload
(defun side-toggle-toggle (tag)
  "Blah TAG."
  (interactive)
  (side-toggle--set-spec tag)
  (pcase (side-toggle--current-mode)
    ('visible (side-toggle--close-window (side-toggle--find-window)))
    ('exists  (side-toggle--open-window (side-toggle--find-buffer)))
    ('none    (side-toggle--open-window (side-toggle--open-buffer)))))


(defun side-toggle--current-mode ()
  "Blah."
  (cond
    ((side-toggle--find-window) 'visible)
    ((side-toggle--find-buffer) 'exists)
    (t 'none)))


(defun side-toggle--open-buffer ()
  "Blah."
  (let*
      ((fn (map-elt side-toggle--spec 'get-buffer))
       (buffer (funcall fn)))
    (with-current-buffer buffer
      (rename-buffer (side-toggle--buffer-name))
      buffer)))

(defun side-toggle--is-buffer (buffer)
  "Blah BUFFER."
  (and
   (s-equals? (buffer-name buffer) (side-toggle--buffer-name))
   (buffer-live-p buffer)))

(defun side-toggle--find-buffer ()
  "Blah."
  (->> (buffer-list)
       (-first 'side-toggle--is-buffer)))


(defun side-toggle--tag ()
  "Blah."
  (map-elt side-toggle--spec 'tag))

(defun side-toggle--buffer-name ()
  "Blah."
  (format " *side-%s*" (side-toggle--tag)))

(defun side-toggle--set-spec (tag)
  "Blah TAG."
  (setq side-toggle--spec (map-elt side-toggle--specs tag)))


(defun side-toggle--find-window ()
  "Blah."
  (->> (window-list)
        (-first (lambda (w) (window-parameter w (side-toggle--tag))))))

(defun side-toggle--open-window (buffer)
  "Blah BUFFER."
  (let*
      ((params (append
                (map-elt side-toggle--spec 'params)
                `((window-parameters . ((,(side-toggle--tag) . t))))))
       (window (display-buffer-in-side-window buffer params))
       (width1 (window-total-width window))
       (state  (frame-parameter nil 'side-toggle-state))
       (width2 (map-elt state (side-toggle--tag) 60))
       (delta  (- width2 width1)))
    (window-resize window delta t)))

(defun side-toggle--close-window (window)
  "Blah WINDOW."
  (let ((width  (window-total-width window)))
    (map-put (frame-parameter nil 'side-toggle-state) (side-toggle--tag) width)
    (delete-window window)))


(provide 'side-toggle)
;;; side-toggle.el ends here
