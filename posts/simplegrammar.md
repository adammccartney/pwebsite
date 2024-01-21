title: Simplegrammar
date: 2021-04-18 10:30
tags: parsing, grammar, music
---

# A simple grammar for music notation

A few years ago, I became interested in the prospect of using 
[GNU Lilypond]({{< ref "http://www.lilypond.org" >}}) as a
way to typeset musical scores. I knew about Lilypond and its Python API abjad
through a fairly nifty hacker called Piaras Hoban, who was doing a doctorate at
UCC at the same time I was skulking about as an undergraduate. This was back in
2008/2009. Actually, looking back on it, the environment in Cork was really
conducive to cooperation between students and there was very little emphasis on
making any really painful distinctions between grad and undergrad students.
I mention this as a side note or preamble to what exactly this post is about.

Lilypond lets you express musical ideas in a very succinct form. It's a powerful 
language and lets you do pretty much anything you want in terms of typesetting
music but if you look at the very core of its syntax for expressing musical
content, it's very elegant.

For example, the phrase:

```

c''2 d''2 f''2. e''4 fs''1

```

Can be explained in terms of a grammar where: 

```
{phrase}             := {complex tone} | {complex tone} {phrase}
{complex tone}       := {pitch}{complex rhythm}
{complex rhyhthm}    := {rhythm} | {rhythm}{augmentation}
{pitch}              := {pitchclass}{octave} | {pitch_regex}{accidental}{octave}
{rhythm}             := {rhythm_regex} | {rhythm_regex}{augmentation_regex}
{pitchclass}         := {pc_regex}
{octave}             := {oct_regex}
{oct_regex}          := /\'*|\,*/
{pc_regex}           := /[A-Ga-g]|[Rr]/
{accidental_regex}   := /|[f]*|(qf)?|(qs)?|[s]*|t?q?[fs]/
{rhythm_regex}       := /\d+/
{augmentation_regex} := /[.]+/
```

This is kind of a quick and dirty explanation that goes for the root of what is
going on in terms of information within a string containing a musical phrase
written in lilypond. Regular expressions (regex above) are a useful way to
manipulate musical information within a score when you are editing lilypond
with an editor like Frescobaldi. Actually, they are useful for editing any
language in any editor.

What took me longer to realise was that regular expressions are also very
useful if you want to write something that is accepted by a finite state
machine. Languages contained within the Chomsky Hierarchy are one of the core 
building blocks in computer science. Unfortunately they are not yet teaching 
composers about regular languages at music university...so we have to somehow
figure it out ourselves.

What basically attracted me to working with Lilypond a few years back, was that
it seemed to open up some interesting possibilities for representing musical
ideas in different ways. I've been interested in the music of Morton Feldman
for a long time, where very subtle differences in notation are a central
feature of the style. 

[abjad]({{< ref "https://abjad.github.io/" >}}) is an API for "Formalized Score Control" 
and it is very handy for manipulating lilypond strings. If you're patient it's 
also a pretty good way to manage scores. If longterm maintainability is your thing, 
you may want to consider either using a more minimal setup, or building your own
interface library for abjad as the codebase gets refactored frequently. 

Anyway, the point being that tools like abjad make it very easy to control
aspects of a music score at a high level. This got me thinking about the idea
of possibly trying to write a sort of 
notated [generative music]

So this year, Thomas Grill and I have been working together as part of the 
[rotting sounds]({{< ref "https://rottingsounds.org" >}}) rotting sounds</a> project. The project is largely
focused on obsolesence and decay of digital audio. We spent a few months
working on a score for ensemble and created an automated build process that
exposed the compiled binary data to erosion each time a build is run,
generating variations on the original score. The source code for the project is
up on github under *rill*.
