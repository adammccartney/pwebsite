;;; again, pilfered from David Thompson
;;; Copyright © 2018-2021 David Thompson <davet@gnu.org>
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

(define-module (markdown)
  #:use-module (commonmark)
  #:use-module (haunt post)
  #:use-module (haunt reader)
  #:use-module (highlight)
  #:use-module (sxml match)
  #:use-module (sxml transform)
  #:export (commonmark-reader*))

(define (sxml-identity . args) args)

;; Markdown doesn't support video, so let's hack around that!  Find
;; <img> tags with a ".webm" source and substitute a <video> tag.
(define (media-hackery . tree)
  (sxml-match tree
    ((img (@ (src ,src) . ,attrs) . ,body)
     (if (string-suffix? ".webm" src)
         `(video (@ (src ,src) (controls "true"),@attrs) ,@body)
         tree))))

(define %commonmark-rules
  `((code . ,highlight-code)
    (img . ,media-hackery)
    (*text* . ,(lambda (tag str) str))
    (*default* . ,sxml-identity)))

(define (post-process-commonmark sxml)
  (pre-post-order sxml %commonmark-rules))

(define commonmark-reader*
  (make-reader (make-file-extension-matcher "md")
               (lambda (file)
                 (call-with-input-file file
                   (lambda (port)
                     (values (read-metadata-headers port)
                             (post-process-commonmark
                              (commonmark->sxml port))))))))
