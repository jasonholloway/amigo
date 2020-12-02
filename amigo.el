;;; amigo.el --- blah blah

;;; Commentary:
;;; wibble wibble

;;; Code:

;;; -*- lexical-binding t; -*-

(require 'subr-x)
(require 'map)
(require 'seq)

(defvar amigo--specs)
(setq amigo--specs '())

(defvar amigo--spec)
(setq amigo--spec '())


;;;###autoload
(defun amigo-specify (tag spec)
  "Add amigo SPEC named by TAG."
  (map-put spec 'tag tag)
  (map-put amigo--specs tag spec))


;;;###autoload
(defun amigo-toggle (tag)
  "Toggle visibility of amigo window named by TAG."
  (interactive)
  (amigo--set-spec tag)
  (pcase (amigo--current-mode)
    (`(visible ,w) (amigo--close-window w))
    (`(exists ,b)  (amigo--open-window b))
    ('(none)       (amigo--open-window (amigo--open-buffer)))))


(defun amigo--current-mode ()
  "Blah."
  (or
   (when-let (window (amigo--find-window))
     `(visible ,window))
   (when-let (buffer (amigo--find-buffer))
     `(exists ,buffer))
   '(none)))


(defun amigo--open-buffer ()
  "Blah."
  (let*
      ((fn (map-elt amigo--spec 'get-buffer))
       (buffer (funcall fn)))
    (with-current-buffer buffer
      (rename-buffer (amigo--buffer-name))
      buffer)))

(defun amigo--is-buffer (buffer)
  "Blah BUFFER."
  (and
   (string= (buffer-name buffer) (amigo--buffer-name))
   (buffer-live-p buffer)))

(defun amigo--find-buffer ()
  "Blah."
  (seq-find
   'amigo--is-buffer
   (buffer-list)))


(defun amigo--tag ()
  "Blah."
  (map-elt amigo--spec 'tag))

(defun amigo--buffer-name ()
  "Blah."
  (format " *side-%s*" (amigo--tag)))

(defun amigo--set-spec (tag)
  "Blah TAG."
  (setq amigo--spec (map-elt amigo--specs tag)))


(defun amigo--find-window ()
  "Blah."
  (seq-find
   (lambda (w) (window-parameter w (amigo--tag)))
   (window-list)))

(defun amigo--open-window (buffer)
  "Blah BUFFER."
  (let*
      ((params (append
                (map-elt amigo--spec 'params)
                `((window-parameters . ((,(amigo--tag) . t))))))
       (window (display-buffer-in-side-window buffer params))
       (width1 (window-total-width window))
       (state  (frame-parameter nil 'amigo-state))
       (width2 (map-elt state (amigo--tag) 60))
       (delta  (- width2 width1)))
    (window-resize window delta t)
    (select-window window)))

(defun amigo--close-window (window)
  "Blah WINDOW."
  (let ((width  (window-total-width window)))
    (map-put (frame-parameter nil 'amigo-state) (amigo--tag) width)
    (delete-window window)))


(provide 'amigo)
;;; amigo.el ends here
