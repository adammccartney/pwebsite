---
title: "Not knowing programming environments"
date: 2024-06-29T17:27:34+02:00
draft: false

---

## Background

At some point over the past couple of years I read an essay written by Bram
Moolnaar called [7 habits of effective text
editing](https://www.moolenaar.net/habits.html). One of the main takeaways for
me is that it is _ok_ to invest time in learning your tools. Although it's
sometimes cumbersome to do so, paying attention to the details of how they work
can often reveal valuable knowledge about their operational context. Knowledge
is power, as cliché goes, and knowing some of the finer details of how your
environment is set up can enable you to design more elegant solutions by
leveraging existing functionality.

Lately I\'ve been editing code with Emacs. I\'ve taken notes using org-mode for
notes for years, but only used it a few times intermittently as a code editor.
Generally I\'ve preferred vim, and more recently Neovim. The later has been
especially fun since the developers did such a good job at integrating LSP
support. It\'s been my experience that from Neovim version 0.5 (or 0.6) a user
only needs to add a couple of plugins to have a relatively smooth LSP
experience. It does of course mean installing various language servers on the
system that runs Neovim, so it means it\'s not the most portable setup.

I've written [elsewhere](/programming/idk-guile-guix) on this site about
experimenting with Guix. After a few months of experimenting with Guix, I\'m
getting to a stage where I have some faint idea of what is going on. Although
the learning curve has been relatively steep, it\'s actually been quite a fun
and interactive way to get to know more about different types of _shells_ and
_profiles_. The notion of a shell should be familiar to anyone who has worked
with a Unix like system before and the Guix notion of a shell is very close to
the standard conception. How Guix uses the concept of profiles is to essentially
make a specific type of shell environment persistent. The abstraction is very
simple, but quite powerful when coupled with [the
store](https://guix.gnu.org/manual/en/html_node/The-Store.html). Later in this
blog post I'll show how I leverage `guix shell`, `GUIX_PROFILE` and some core
Emacs functionality to make a reproducible development environment for python
Django projects.

## The good old days of virtual environments

In my current setup, the default python interpreter is the \"host\"
system interpreter. This is also the one that I use to create most of my
virtual environments. For the management of virtual environments, I tend
to use *virtualenvwrapper*, a fairly simple set of bash functions that
make the management of python\'s virtual environments a bit easier.

To keep things even more simple, it\'s worth pointing out that there is
a standard way to get in and out of virtual environments in python.
After a virtual environment is created (in this case using python\'s
venv module), a script is created at
`PATH_TO_VENV/bin/activate`. Sourcing this script does a
couple of important things:

-   it defines a `deactivate` function to undo the following
    modifications
-   it modifies the PATH variable, prepends the
    `PATH_TO_VENV/bin` to the front of the list, this means
    any program searching the PATH for common python binaries will find
    the ones installed in the virtual environment first.
-   it sets the `VIRTUAL_ENV` environment variable

It also does a couple of other things

-   It manipulates the prompt
-   It unsets `PYTHONHOME` if it has been set
-   It un-aliases _pydoc_, then creates a new alias that will use the _pydoc_
    version from the virtual env.

If we are in a shell session and source the `activate` script of a virtual
environment, we modify the interactive shell session in such a way that the
commands we try to run will first attempt to find the appropriate program in the
`bin` directory of the virtual environment before searching other possible
system paths. This offers another easy win, any child process that gets forked
from that shell session where the virtual environment is activated inherits the
same set of environment variables from the parent. This is useful because
typically python environments are used as lightweight encapsulation for
installing a set of dependencies that you maybe don't want to run everywhere.
For instance, often times you want to run a language server or a debugger in
such a way that it has knowledge of all the libraries that a program is using.

## Editing python code

As mentioned above, simply activating a virtual environment before launching
your editor will make it more likely that certain functionality will work by
virtue of the way that your `PATH` variable is set up. In fact, this is
typically the pattern that I use when editing code with a modal editor like Vim.
Note that something like the typical repl workflow or running an LSP server are
typically handled by plugins in the Vim ecosystem. Vim plugins are written in
Vimscript and Neovim uses Lua as a scripting language. In fact, not having to
learn Vimscript to write plugins was one of the major reasons that some [long
term Vim users](https://youtu.be/T7TAX653_OM?feature=shared) cited as one of the
reasons for the move to Neovim.

Over in Emacs land, things are set up a bit differently. While the community
also relies heavily on plugins, there seems to be a good tradition of merging
the code for certain tools into the core Emacs repository once they have proved
their usefulness and reached a certain level of maturity. There may also be
other arbitrary criteria that needs to be fulfilled. But for the most part, it
seems that some really useful plugins wind up becoming part of the core Emacs
package. I've heard that one of the points of evaluation for plugins before such
an inclusion happens is how well the code leverages existing Emacs APIs. I'll
mention a few such projects below.

Emacs built in python mode is one such instance of absorption. And in it's
modern incarnation, `python.el` offers a very straight forward way to get a
virtualenv configured correctly. Basically, one just needs to set the
`python-shell-virtualenv-root` variable. The built-in python mode then does the
rest. For further convenience, it's also possible to use a `.dir-locals.el` file
in the root of your project to ensure that the correct path is set by default
when we open a python file in that project for the first time:

```elisp
((python-mode . ((python-shell-virtualenv-root . "~/.virtualenvs/foo/"))))
```

This pattern works nicely with `project.el` and once a dir-locals file has be
created for each project, the value associated with the variable will change
depending on the file that we load into a buffer. This makes it practical to run
different version of the python interpreter if we so wish. (Just make sure that
each buffer containing a repl gets a unique name!)

This is already pretty useful in the development workflow as any python repl
started will default to the interpreter found in the `bin/` directory of that
virtualenv.

### Code completion


## Using Guix shell

```elisp
((python-mode . ((python-shell-virtualenv-root . "/gnu/store/841bxswc9qh0h4b865n5903hk03h4k6d-profile/"))))
```

[blog post on python hacking in emacs](https://robbmann.io/posts/006_emacs_2_python/)





