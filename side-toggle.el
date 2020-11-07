;;; side-toggle.el --- blah blah
;;; Package-Requires: ((dash "2.17.0"))

;;; Commentary:
;;; wibble wibble

;;; Code:

;;; -*- lexical-binding t; -*-


(-first 'side-toggle--is-buffer (buffer-list))


(side-toggle--find-window)

(window-total-width
 (side-toggle--find-window))


(side-toggle--current-mode)

(side-toggle--find-buffer)
(side-toggle--open-buffer)

(side-toggle--find-window)
(side-toggle--open-window (side-toggle--find-buffer))

(window-parameters
 (side-toggle--find-window))

(defun side-toggle--open-window (buffer)
  "Blah BUFFER."
  (display-buffer-in-side-window
    buffer
    '((side . right)
      (window-parameters . ((side-toggle--window-tag . t))))))

(defun side-toggle--close-window (window)
  "Blah WINDOW."
  (let ((width (window-total-width window)))
    (set-frame-parameter nil 'side-toggle-width 123)
    (delete-window window)))

(frame-parameters nil)

(side-toggle-toggle)


(defconst side-toggle--buffer-name-prefix " *side-toggle-")
(defconst side-toggle--window-tag "side-toggle")

;;;###autoload
(defun side-toggle-toggle ()
  "Blah."
  (interactive)
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
  (get-buffer "*terminal*"))


(defun side-toggle--find-window ()
  "Blah."
  (->> (window-list)
       (-first (lambda (w) (window-parameter w 'side-toggle--window-tag)))))

(defun side-toggle--is-buffer (buffer)
  "Blah BUFFER."
  (and
   (s-starts-with? "*termi" (buffer-name buffer))
   (buffer-live-p buffer)))

(defun side-toggle--find-buffer ()
  "Blah."
  (->> (buffer-list)
       (-first 'side-toggle--is-buffer)))

(provide 'side-toggle)
;;; side-toggle.el ends here
