;;; Copyright © 2024 Adam McCartney <adam@mur.at>
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

(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module (utils)
  #:export (admccartney-theme))

(define admccartney-theme
  (theme #:name "admccartney"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (head
              (meta (@ (charset "utf-8")))
              (title ,(string-append title " - " (site-title site)))
              ,(stylesheet "Iosevka")
              ,(stylesheet "admccartney"))
             (body
              (div (@ (class "container"))
                   (div (@ (class "nav"))
                        (ul (li ,(link "Adam McCartney" "/"))
                            (li ,(link "About" "/about.html"))
                            (li ,(link "Blog" "/index.html"))
                            (li ,(link "Music" "/music.html"))))
                   ,body
                   (footer (@ (class "text-center"))
                           (p (@ (class "copyright"))
                                 "© 2024 Adam McCartney")
                           (p "This website is built with "
                              (a (@ (href "https://dthompson.us/projects/haunt.html"))
                                 "Haunt")
                              ", a static site generator written in "
                              (a (@ (href "https://gnu.org/software/guile"))
                                 "Guile Scheme")
                              "."))))))))
