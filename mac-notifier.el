;;; mac-notifier.el --- Native notifier for Mac 9.x & 10.x

;; Copyright (C) 2016  Eric Hansen

;; Author: Eric Hansen <hansen.c.eric@gmail.com>
;; Maintainer: Eric Hansen <hansen.c.eric@gmail.com>
;; URL: https://github.com/eric-hansen/mac-notifier
;; Version: 0.0.1
;; Keywords: emacs eric-hansen mac notify native
;; Package-Requires: ((emacs "24.3"))

;; This file is not part of GNU Emacs

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A nice little native Mac notifier library that tells the user something.
;; There's libraries that are either general purpose or use third-party
;; programs to give the same effect but this is meant to just be a simple, clean
;; solution.
;; All you need to do is call mac-notifier-notify and pass in the message and title.
;; You can also optionally pass in a subtitle and sound file if requested.

;;; News:

;;;; Changes since 0.0.0:
;; - Created the project

(require 'cl-lib)

(defvar mac-notifier-should-run nil "Checks to see if the system is darwin or not.  If not then why should this be used?")
(defvar mac-notifier-initialized nil "Set to non-nil when this library gets initialized.")

(defun mac-notifier-init ()
  "Initialize the notifier library.  Must be ran before any other functions will."
  (message "System type: %s" system-type)
  (if (eq system-type 'darwin)
	(setq mac-notifier-should-run t))

  (setq mac-notifier-initialized t))

(cl-defun mac-notifier-notify (body title &key (subtitle "") (sound ""))
  "Sends a notification to the Mac OS set up so we can tell the user something super duper awesome happened!

  If you want something more informative you can also pass in keys for a subtitle and sound, like so:

  (mac-notifier-notify <some text> <some title> :subtitle <subtitle here> :sound <sound file>)

  Since this just calls AppleScript you need to conform the values to what can be passed in here, this is mostly
  important when passing in a value to sound.
"
  (interactive "sMessage to tell user: \nsNotification title: ")
  (unless mac-notifier-initialized
    (mac-notifier-init))
  
  (unless mac-notifier-should-run
    (user-error "This can only run on Mac systems."))

  (let ((notify-cmd (format "osascript -e 'display notification %S with title %S" body title)))
    (if (not (eq "" subtitle))
	(setq notify-cmd (format "%s with subtitle %S" subtitle)))
    (if (not (eq "" sound))
	(setq notify-cmd (format "%s with sound %S" sound)))
    (shell-command-to-string (format "%s'" notify-cmd))))

(provide 'mac-notifier)

;;; mac-notifier.el ends here
