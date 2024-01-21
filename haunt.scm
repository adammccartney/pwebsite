(use-modules (haunt asset)
             (haunt site)
             (haunt builder assets)
             (haunt builder blog)
             (haunt builder atom)
             (haunt reader commonmark))

(site #:title "admu"
      #:domain "admccartney.mur.at"
      #:default-metadata
      '((author . "Adam Mc Cartney")
        (email . "adam@mur.at"))
      #:readers (list commonmark-reader)
      #:builders
      (list (blog #:theme admccartney-theme)
            (atom-feed #:max-entries 1024)
            (atom-feeds-by-tag)
            (static-directory "css")))
  
