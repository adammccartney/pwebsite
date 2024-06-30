---
title: "Not knowing Guile or Guix"
date: 2024-06-22T15:49:40+02:00
draft: false

tags: ["Guile", "Guix", "Scheme", "Failure"]
series: ["not knowing"]
---

If you bumped into a person who happened to have the slightest brush with the
liberal arts end of a university in the western world at some point over the
last fifty years, then you may well have heard the term \"the medium is the
message\". The phrase is the title given to the first chapter of one of Marshall
McCluhan's books[^1]. The phrase, like all bits of philosophical wisdom, is
open to interpretation. Probably the most frequently articulated angle is that
the nature of the medium, through which a message is communicated, forms an
essential component of what is being communicated. In the opening few paragraphs
of that essay, McLuhan mentions a couple of large companies of the day, the
1960s. In particular, he draws a comparison between General Electric and AT&T,
and states that both companies are in fact in the business of moving
information, only the latter seems to have realized it.

Anyway, I\'m not really sure why I started off talking about Marshall
McCluhan. I thought there would be some interesting segway to the world
of hackers, and how hackers love to hack - that there doesn\'t
necessarily need to be any tangible utility other than the activity
itself. Basically this is a round about way of saying that I\'ve decided
to rewrite my blog using guile and guix.

## Learn to scheme in just 16 short years!

[Guile](https://gnu.org/software/guile) is a scheme, a dialect of lisp.
Specifically, it is the \"programming and extension language\" of GNU. My first
encounter with guile was in the GNU Lilypond project, where I unwittingly used
it to apply a few typesetting tweaks to music scores. At the time, I was looking
for ways to automate the generation of lilypond syntax, or in other words, I
wanted to generate music scores. Even though by 2008 I think I had gotten as far
as downloading a copy of emacs, I hadn\'t managed to get it doing much and so
had remained blissfully unaware of the world of lisp, and also the potential of
a language like like scheme for code generation tasks.

Python was very much in vogue at the time (spoiler: it still is!). Many of my
friends and colleagues were using it and there were plenty of learning resources
available, so that\'s the route I ended up taking initialy. In fairness, python
can be pretty lispy - apparently the python core team has a few lisp enthusiasts
and [this article](https://norvig.com/python-lisp.html) by Peter Norvig contains
a pretty interesting comparison of the two languages. 

At some point during my adventures with lilypond I bought a copy of [The Little
Schemer](https://mitpress.mit.edu/9780262560993/the-little-schemer/) with the
intention of digging into it as a way to learn how to programmatically generate
lilypond, but I didn\'t get around to reading it until I ended up on a totally
different tangent while reading [Crafting Interpreters](https://craftinginterpreters.com/).

The next time I encountered scheme was while learning a bit of javascript for work. 
Marijn Haverbeke wrote a really nice [book](https://eloquentjavascript.net/) about
writing javascript and the style of code that he writes is very much influenced
by scheme. Of course one canonical computer science scheme book is [Structure
and Interpretation of Computer Programs](https://web.mit.edu/6.001/6.037/sicp.pdf).
And having worked through the first four chapters of that book fairly recently,
I decided to do some scheme hacking in 2024. The community around guile scheme 
seems to be pretty low-key and friendly, and there are a some really interesting
projects like [Guix](https://guix.gnu.org/en/) and [Hoot](https://spritely.institute/hoot/)
that I\'m interested in taking a closer look at. Both projects are somewhat
advanced, so I figured I\'d pick the one that was somewhat more familiar and
start from there.

## guix

Guix is a distribution of the GNU operating system. It\'s designed around the
philosophy of [The Purely Functional Software Deployment
Model](https://edolstra.github.io/pubs/phd-thesis.pdf). that was described by
Eelco Dolstra, the inventor of [Nix](https://nixos.org/), in his PhD thesis. It
shares many fundamental ideas and patterns with NixOS - shells and containers
that enable isolated environments, declaritive package management that makes it
possible to manage dependencies and specify reproducible builds of software.
Both distros have a package manager that can be installed in foreign
distributions, and I\'ve had the chance to play around with both a bit over the
past couple of years. One of the major differences is Nix\'s choice of a custom
domain specific language (DSL). Guix on the other hand opts to use guile scheme.
Scheme is generally considered to be an excellent language for writing DSLs, and
one of the main lessons from Structure and Interpretation of Computer Programs
is the idea of \"Metalinguistic Abstraction\". This is a fancy way to say
inventing new languages to solve a problem. And the authors of that book contend
this is one of the core skills of computer programming.

So, it\'s the prospect of hacking in a language that has more universal
applicability that makes Guix the more interesting of the two projects
in my view. I\'m even willing to put up with some of the sharp edges in
order to use it. If we revisit Mr. McCluhan\'s idea of the medium being
the message for a minute, we could suggest that using a language with a
core facet of inventive problem solving might actually make use better
creative problem solvers! (Or at the very least better at creating
problems that we can solve).

Okay, so enough of the highfalutin whataboutery - are these tools of any
practical use? To answer this question, I picked the relatively benign
task of translating my website from [hugo](https://gohugo.io/) to
[haunt](https://dthompson.us/projects/haunt.html). Both are static site
generators, the former is written in go and was suggested to me by Jogi
Hofmueller from [mur.at](https://mur.at) a number of years ago when I
was redesigning my website. Hugo is a great tool, it\'s simple to use in
an \"out-of-the-box\" kind of way. I\'ve been reading the codebase a bit
recently and thought it was relatively large and complicated for what it
was doing (basically just generating html files). I was surpised to
learn that the repo contains over 170000 lines of go code! Granted,
it\'s probably the website and everything, but it still feels like alot.

``` shell
amccartn@mc ~/.local/src/hugo
> (find ./ -name "*.go" -print0 |xargs -0 cat) | wc -l
173492
```

On the other hand, haunt contains just about 4000 lines of scheme code.
As someone with a limited life-span who wants to do a bit of hacking,
I\'m quite a big fan of projects that I can wrap my head around.

``` shell
amccartn@mc ~/src/haunt.git  (master *)
> (find ./ -name "*.scm" -print0 |xargs -0 cat) |wc -l
4173
```

As a side note, there is an interesting hacker/philosopher called [Protesilaos
Stavrou](https://protesilaos.com/) who makes an interesting claim about
aesthetics somewhere, either on his [blog](https://protesilaos.com/) or
[videoblog](https://www.youtube.com/@protesilaos), I forget exactly where. But
the claim comes down to the effect of choosing human-centric proportions when
making aesthetic decisions. Basically the idea is that by choosing to use simple
structures and elegant form, you make it easier for a person to directly
experience a sense of wholeness - which is fun by the way!

## haunt hacking

So haunt is a handy little program and it does 90% of what I want out of
the box. One feature that I\'d like to retain from hugo is the ability
to generate trees of tag pages based on the tags attached to each post
in a blog. I figure it\'s not too lofty a goal, and it\'s a good way to
test out guix as a tool for development.

### Development environment

So there are a couple of useful blog posts about setting up development
environments with guix, [this one by Steve George](https://www.futurile.net/2023/04/30/guix-reproducible-dev-environments/)
quickly works towards a handy script. I won\'t include the script here, but
I\'ll reference it as `guix-dev-env.sh` in a few snippets below.  Basically, it
goes from the most simple command that can be used to spin up a shell in its own
container. To a script that bascially adds a few more flags to the command and
packages that are required for development. The original post is well worth
reading, it\'s part of a series on guix.

So, starting from the assumption that we can spin up a simple development
environment, let\'s clone the haunt repository, make a change and build a
website to ensure that we have a workflow that ...  works. The haunt repository
contains a `guix.scm` file which gets picked up by the `guix shell` command (by
default if no other packages are passed or explicitly with the `--file` flag as
in the script referenced above. Most of what follows for the rest of this
article is more or less a reptition of Steve's original post on the topic.  As
you'll see if you glance at the end of the end of the post, I didn't get that
far with my original goal. I'll anyway include a few snippits from here just to
reiterate what a development environment environment with guix can look like.

``` shell
amccartn@mc ~/src/haunt.git  (master *)
> ./guix-dev-env.sh
+ exec guix shell --container --network '--preserve=^DISPLAY$' '--preserve=^XAUTHORITY$' --expose=/run/user/1000/.mutter-Xwaylandauth.WHZNI2 --preserve=XDG_RUNTIME_DIR --expose=/run/user/1000 --share=/home/amccartn/.vim --share=/home/amccartn/.vimrc --development --file=./guix.scm --manifest=./guix-dev-env.sh
```

After cloning the haunt, we just want to make some trivial change to
make and build the project to make sure we can rebuild the project.

``` shell
> git show HEAD
commit f0c9302c68470ba72e4aeae91988baabe157f2e1 (HEAD -> master)
Author: Adam McCartney <amccartn@mc.it.tuwien.ac.at>
Date:   Sat Feb 17 15:36:27 2024 +0000

    Minor change to blog builder

diff --git a/haunt/builder/blog.scm b/haunt/builder/blog.scm
index 6ebcd8f..2ee3d6e 100644
--- a/haunt/builder/blog.scm
+++ b/haunt/builder/blog.scm
@@ -61,7 +61,7 @@
   `((doctype "html")
     (head
      (meta (@ (charset "utf-8")))
-     (title ,(string-append title " — " (site-title site))))
+     (title ,(string-append title " — A MODIFIED -" (site-title site))))
     (body
      (h1 ,(site-title site))
      ,body)))
```

After making the changes, we can spin up a fresh environment using guix
shell, it\'s important to pass the `--network` flag here,
this allows the container to share the network namespace with the host
system.

``` shell
amccartn@mc ~/src/haunt.git  (master)
> guix shell --container --nesting --network --preserve=$ coreutils git
```

We can install the modified version of the haunt repository by using the `guix
package` command and passing the correct flags. Note that it\'s also possible to
install the package directly by passing the path to the store item that was
built in a previous step. It seems to depend a bit on whether or not the package
is totally self contained or relies on some external dependencies. In any case,
passing the `guix.scm` file from the haunt repository contains all the required
dependencies.

``` shell
amccartn@mc ~/src/haunt.git [env]$ guix package --install-from-file=guix.scm
amccartn@mc ~/src/haunt.git [env]$ cd example/ && haunt build && haunt serve
```

Once we\'ve installed the new version, used it to build and serve a site, we can
hit the index page from another shell running on the host system and see that
the changes were picked up.

``` shell
amccartn@mc ~
> curl localhost:8080
<!DOCTYPE html><head><meta charset="utf-8" /><title>Recent Posts — A MODIFIED -Built with Guile</title></head><body><h1>Built with Guile</h1><h3>Recent Posts</h3><ul><li><a href="/hello-markdown.html">Hello, Markdown! — Thu 18 August 2016</a></li><li><a href="/hello-texi.html">Hello, Texi! — Thu 15 October 2015</a></li><li><a href="/hello-skribe.html">Hello, Skribe! — Fri 09 October 2015</a></li><li><a href="/a-foo-walks-into-a-bar.html">A Foo Walks Into a Bar — Sat 11 April 2015</a></li><li><a href="/hello-world.html">Hello, world! — Fri 10 April 2015</a></li></ul></body>
```

## p.s.

Note that this site still runs on hugo! I failed at trying to implement an xml
parser that would generate tag pages for me. There are some handy libraries in
scheme for doing this type of thing, based around the idea of _sxml_ (xml
represented as s-expressions). But somewhere along the way to grokking macros,
my brain exploded. I've since managed to slowly piece some of it back together,
so maybe more on this soon.

# Footnotes

[^1]: <https://en.wikipedia.org/wiki/Understanding_Media>
