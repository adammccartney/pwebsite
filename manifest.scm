(use-modules (gnu packages autotools)
             (gnu packages base)
             (gnu packages guile)
             (gnu packages guile-xyz)
             (gnu packages pkg-config)
             (gnu packages rsync)
             (gnu packages texinfo)
             (guix git-download)
             (guix packages)
             (guix profiles)
             (guix utils))

(define guile-syntax-highlight*
  (let ((commit "e40cc75f93aedf52d37c8b9e4f6be665e937e21d"))
    (package
      (inherit guile-syntax-highlight)
      (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.dthompson.us/guile-syntax-highlight.git")
                    (commit commit)))
              (sha256
               (base32
                 "0iqspd8wdxizv0z3adxlxx6bzfx1376qzc4bwbwrdln4p7fc975m"))))
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'bootstrap
             (lambda _ (invoke "sh" "bootstrap"))))))
      (inputs (list guile-3.0-latest))
      (native-inputs (list autoconf automake pkg-config)))))

(define haunt*
  (let ((commit "bdf0ebe0e4e90b14812bccd5bf25d0aeac9ab7b2"))
    (package
     (inherit haunt)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.dthompson.us/haunt.git")
                    (commit commit)))
              (sha256
               (base32
                "0zwyjwzkpn3a31chgy9nlx274hm6jmdbffycynmhjaa5j8x19ji6"))))
     (native-inputs
      (list automake autoconf pkg-config texinfo))
     (inputs
      (list rsync guile-3.0-latest))
     (arguments
      (substitute-keyword-arguments (package-arguments haunt)
        ((#:phases phases)
         `(modify-phases ,phases
            (add-after 'unpack 'bootstrap
              (lambda _
                (invoke "sh" "bootstrap"))))))))))

(packages->manifest
 (list guile-3.0-latest
       guile-syntax-highlight*
       haunt*))
