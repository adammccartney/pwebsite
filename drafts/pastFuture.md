---
title: "Past activities and future plans"
date: 2020-12-22T16:37:00+01:00
draft: true
author: "Adam"

partners: []
tags: ["unix"]

menu:
  main:
    parent: 2020
    name: pastFuture
    url: /music/2020/pastFuture.md


---


# Don't scare the undergraduates

So I've taught undergraduate courses in computer music the past couple of
years in Vienna. In an attempt to keep things accessible and user-friendly,
the tools that I've been using to do this have tended to be gui based with an
emphasis on "patcher" style programming. The computer music courses are roughly
divided in two categories: Sound Synthesis and Computer Aided Composition.

For the sound synthesis course, I settled on using modular (synthesizer) style 
patching in order to convey the necessary concepts. There are a number of
really excellent virtual modular synth environments to choose from: Reaktor
Blocks, Automatonism (for pd) and Beap (for Max) just to name a few. Any one of
these offers plenty of scope and can be used as a professional level tool. The
only things to keep in mind is that they are either proprietary (Max and
Reaktor) or require a little bit of hacker-like curiosity (pd). Unfortunately
the school where I was teaching didn't provide any workstations or help with
acquiring licences for staff or students. This set of constraints meant that
ideally whatever program I could teach on should be *a)* easily installable
across the mostly osx / windows laptops that the students were themselves using 
and *b)* could run more or less out of the box. 

The program I eventually settled on was *VCV Rack*, a new open source project 
great! I taught the course a total of three times over the past couple of
years, so I've even got a script that might be moderately useful to someone.
It currently exists as an org / html / pdf file over on my github. This was the
easiest quickest way for me to share and regularly update the script as I was
moving through the semester. I'll make a new home for it on here over the
coming weeks and perhaps leave a source only version of the repo up on github,
which also contains a few example patches in vcv.   

# A little bit of unix hacking 

Okay, so what I've been spending a whole lot of time doing over this past year
is getting to grips with linux. I've been exploring the music notation language
Lilypond over the past couple of years. This is a piece of GNU software that
if very useful for pulication quality music scores. In fact, a lot of the
scores documented visually on this site in the Music/Scores section from about
2017 onwards use Lilypond. They are currently being presented as jpegs of the
finished score. A format that is quite useful for musicians, but possibly less
useful for any aspiring music/unix hackers. I'm going to go back over these
pages and introduce some source code examples.

Lilypond lets you express musical structures in plain text, which of course
opens up some interesting possibilities for modelling certain types of musical
ideas formally. In fact, there is a very useful API for python called abjad
that lets you do just that. There's a bit of a learning curve with abjad, as it
essentially means having to develop a fairly good working knowledge of python
and some general hacking skills. So, what I'm proposing to do is to document 
some of this journey into the world of music making with linux. 
