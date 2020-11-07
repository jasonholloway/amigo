;;; sideterm.el --- blah blah
;;; Package-Requires: ((dash "2.17.0"))
;;; Package-Requires: ((names "20150723.0"))

;;; Commentary:
;;; wibble wibble

;;; Code:

;;; -*- lexical-binding t; -*-


(-first 'sideterm--is-buffer (buffer-list))


(sideterm--find-window)

(window-parameters
 (sideterm--find-window))

(window-total-width
 (sideterm--find-window))


(sideterm--current-mode)
(sideterm-toggle)

(sideterm--find-buffer)
(sideterm--open-buffer)




(defconst sideterm--buffer-name-prefix " *sideterm-")

;;;###autoload
(defun sideterm-toggle ()
	"Blah."
	(interactive)
	(pcase (sideterm--current-mode)
		('visible (sideterm--close-window (sideterm--find-window)))
		('exists  (sideterm--open-window (sideterm--find-buffer)))
		('none    (sideterm--open-window (sideterm--open-buffer)))))

(defun sideterm--current-mode ()
	"Blah."
	(cond
		((sideterm--find-window) 'visible)
		((sideterm--find-buffer) 'exists)
		(t 'none)))

(defun sideterm--open-window (buffer)
	"Blah BUFFER."
	(display-buffer-in-side-window
		buffer
		'((side . right)
			(window-parameters . ((sideterm . t))))))

(defun sideterm--close-window (window)
	"Blah WINDOW."
	(delete-window window))

(defun sideterm--open-buffer ()
	"Blah."
	(get-buffer "*terminal*"))

(defun sideterm--find-window ()
	"Blah."
	(->> (window-list)
			 (-first (lambda (w) (window-parameter w 'sideterm)))))

(defun sideterm--is-buffer (buffer)
	"Blah BUFFER."
	(s-starts-with? "*termi" (buffer-name buffer)))

(sideterm--find-buffer)

(defun sideterm--find-buffer ()
	"Blah."
	(->> (buffer-list)
			 (-first (lambda (b)
								 (and (sideterm--is-buffer b) (buffer-live-p b))))))

(provide 'sideterm)
;;; sideterm.el ends here
