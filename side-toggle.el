;;; side-toggle.el --- blah blah
;;; Package-Requires: ((dash "2.17.0"))

;;; Commentary:
;;; wibble wibble

;;; Code:

;;; -*- lexical-binding t; -*-


(-first 'side-toggle--is-buffer (buffer-list))


(side-toggle--find-window)

(window-parameters
 (side-toggle--find-window))

(window-total-width
 (side-toggle--find-window))


(side-toggle--current-mode)
(side-toggle-toggle)

(side-toggle--find-buffer)
(side-toggle--open-buffer)




(defconst side-toggle--buffer-name-prefix " *side-toggle-")

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

(defun side-toggle--open-window (buffer)
  "Blah BUFFER."
  (display-buffer-in-side-window
    buffer
    '((side . right)
      (window-parameters . ((side-toggle . t))))))

(defun side-toggle--close-window (window)
  "Blah WINDOW."
  (delete-window window))

(defun side-toggle--open-buffer ()
  "Blah."
  (get-buffer "*terminal*"))

(defun side-toggle--find-window ()
  "Blah."
  (->> (window-list)
       (-first (lambda (w) (window-parameter w 'side-toggle)))))

(defun side-toggle--is-buffer (buffer)
  "Blah BUFFER."
  (s-starts-with? "*termi" (buffer-name buffer)))

(side-toggle--find-buffer)

(defun side-toggle--find-buffer ()
  "Blah."
  (->> (buffer-list)
       (-first (lambda (b)
                 (and (side-toggle--is-buffer b) (buffer-live-p b))))))

(provide 'side-toggle)
;;; side-toggle.el ends here
