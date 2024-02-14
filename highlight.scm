;;; This stuff snarfed from David Thompson
;;; so Copyright © 2018-2021 David Thompson <davet@gnu.org>
;;; and GPLv3+

;; https://git.dthompson.us/blog.git/tree/highlight.scm

(define-module (highlight)
  #:use-module (ice-9 match)
  #:use-module (sxml match)
  #:use-module (syntax-highlight)
  #:use-module (syntax-highlight scheme)
  #:use-module (syntax-highlight xml)
  #:use-module (syntax-highlight c)
  #:use-module (syntax-highlight python)
  #:export (highlight-code
            highlight-scheme))

(define (maybe-highlight-code lang source)
  (let ((lexer (match lang
                 ('scheme lex-scheme)
                 ('lisp   lex-lisp)
                 ('xml    lex-xml)
                 ('c      lex-c)
                 ('python lex-python)
                 (_ #f))))
    (if lexer
        (highlights->sxml (highlight lexer source))
        source)))

(define (highlight-code . tree)
  (sxml-match tree
    ((code (@ (class ,class) . ,attrs) ,source)
     (let ((lang (string->symbol
                  (string-drop class (string-length "language-")))))
       `(code (@ ,@attrs)
             ,(maybe-highlight-code lang source))))
    (,other other)))

(define (highlight-scheme code)
  `(pre (code ,(highlights->sxml (highlight lex-scheme code)))))
