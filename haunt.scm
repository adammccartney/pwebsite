
(use-modules (haunt asset)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt builder flat-pages)
             (haunt builder redirects)
             (haunt post)
             (haunt site)
             (haunt reader commonmark)
             (theme)
             (utils))

(site #:title "admu"
      #:domain "admccartney.mur.at"
      #:default-metadata
      '((author . "Adam Mc Cartney")
        (email . "adam@mur.at"))
      #:readers (list commonmark-reader)
      #:builders (list (blog #:theme admccartney-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       (flat-pages "pages"
                                   #:template (theme-layout admccartney-theme))
                       (static-directory "css")
                       (static-directory "fonts")))


