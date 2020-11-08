;;; side-toggle.el --- blah blah
;;; Package-Requires: ((dash "2.17.0"))

;;; Commentary:
;;; wibble wibble

;;; Code:

;;; -*- lexical-binding t; -*-


;; (-first 'side-toggle--is-buffer (buffer-list))


;; (side-toggle--find-window)

;; (window-total-width
;;  (side-toggle--find-window))


;; (side-toggle--current-mode)

;; (side-toggle--find-buffer)
;; (side-toggle--open-buffer)



;; (window-parameters
;;  (side-toggle--find-window))


(defvar side-toggle--specs)
(setq side-toggle--specs
      '((test . ((tag . test)
                 (params . ((side . right))))
              )))

;; (side-toggle--set-spec 'test)
;; (side-toggle--tag)


(defvar side-toggle--spec)
(setq side-toggle--spec '())



(side-toggle-toggle 'test)

side-toggle--spec

(side-toggle--set-spec 'test)
(side-toggle--current-mode)

(side-toggle--open-window (side-toggle--find-buffer))
(side-toggle--close-window (side-toggle--find-window))


(seq-map 'window-parameters (window-list))
(side-toggle--find-window)

(frame-parameter nil 'side-toggle-state)
(set-frame-parameter nil 'side-toggle-state nil)



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
  (get-buffer "*terminal*"))

(defun side-toggle--is-buffer (buffer)
  "Blah BUFFER."
  (and
   (s-starts-with? "*termi" (buffer-name buffer))
   (buffer-live-p buffer)))

(defun side-toggle--find-buffer ()
  "Blah."
  (->> (buffer-list)
       (-first 'side-toggle--is-buffer)))


(defun side-toggle--tag ()
  "Blah."
  (map-elt side-toggle--spec 'tag))

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
