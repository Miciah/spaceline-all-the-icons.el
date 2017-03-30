;;; spaceline-all-the-icons.el --- A Spaceline theme using All The Icons

;; Copyright (C) 2017  Dominic Charlesworth <dgc336@gmail.com>

;; Author: Dominic Charlesworth <dgc336@gmail.com>
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3") (all-the-icons "2.4.0"))
;; URL: https://github.com/domtronn/spaceline-all-the-icons.el
;; Keywords: convenience, lisp, tools

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'spaceline)
(require 'bookmark)

;; toggle-on/-off  Toggle Switch
;; link/-broken    Chain with break
(defgroup spaceline-all-the-icons nil
  "Customize the the Spaceline All The Icons mode line and theming."
  :prefix "spaceline-all-the-icons-"
  :group 'appearance
  :group 'convenience)

(defcustom spaceline-all-the-icons-icon-set-modified '("link" . "chain-broken")
  "The Icon set to use for the modified indicator."
  :group 'spaceline-all-the-icons
  :type '(radio
          (const :tag "Toggle Switch     On / Off" ("toggle-on" . "toggle-off"))
          (const :tag "Chain Links       Solid / Broken" ("link" . "chain-broken"))))

(defcustom spaceline-all-the-icons-icon-set-bookmark '((icon (on . "bookmark") (off . "bookmark-o"))
                                                       (echo (on . "Bookmark") (off . "Remove Bookmark")))
  "The Icon set to use for the bookmark indicator."
  :group 'spaceline-all-the-icons
  :type '(radio
          (const :tag "Bookmark Icon" ((icon (on . "bookmark") (off . "bookmark-o"))
                                       (echo (on . "Bookmark") (off . "Remove Bookmark"))))
          (const :tag "Heart Icon   " ((icon (on . "heart") (off . "heart-o"))
                                       (echo (on . "Like") (off . "Unlike"))))
          (const :tag "Star Icon    " ((icon (on . "star") (off . "star-o"))
                                       (echo (on . "Star") (off . "Unstar"))))))

;; Segments
(spaceline-define-segment
    all-the-icons-modified "An `all-the-icons' segment depiciting the current buffers state"
    (let* ((buffer-state (format-mode-line "%*"))
           (icon (cond
                  ((equal buffer-state "-") (car spaceline-all-the-icons-icon-set-modified))
                  ((equal buffer-state "*") (cdr spaceline-all-the-icons-icon-set-modified))
                  ((equal buffer-state "%") "lock"))))
      (propertize (all-the-icons-faicon icon :v-adjust -0.0)
                  'face `(:family ,(all-the-icons-faicon-family) :height 1.1 :inherit)))
     :tight t)

(spaceline-define-segment
    all-the-icons-bookmark "An `all-the-icons' segment allowing for easy bookmarking of files"
    (progn
      (unless (boundp 'bookmark-alist) (bookmark-all-names)) ;; Force bookmarks to load
      (let-alist spaceline-all-the-icons-icon-set-bookmark
        (let* ((bookmark-name (buffer-file-name))
               (bookmark (find-if (lambda (it) (equal bookmark-name (car it))) bookmark-alist)))

          (propertize (all-the-icons-faicon (if bookmark .icon.on .icon.off) :v-adjust 0.0)
                      'pointer   'hand
                      'help-echo  (if bookmark .echo.off .echo.on)
                      'face      `(:family ,(all-the-icons-faicon-family) :inherit)
                      'local-map  (make-mode-line-mouse-map
                                   'mouse-1
                                   `(lambda () (interactive)
                                      (if ,(car bookmark)
                                          (bookmark-delete ,(car bookmark))
                                          (bookmark-set ,bookmark-name))
                                      (force-window-update)))))))

    :when (buffer-file-name))

(provide 'spaceline-all-the-icons)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; spaceline-all-the-icons.el ends here
