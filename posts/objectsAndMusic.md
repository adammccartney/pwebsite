title: Not knowing...functional programming
date: 2021-05-11 14:53
tags: music, oops, functional
---

There is a funny story from the composer Morton Feldman. The full story can be
found somewhere in the book *Give My Regards to Eighth Street*, and I'll relay
the gist of what he was trying to say here. At some point a young man was
taking lessons with the composers and trying to write some "modern" piano
music. The first week, the student came by and had a piano piece with lots of
notes in the middle register. The teacher told him to be careful not to write
too much in the middle register, everything there will sound like a choral. So
the next week the young man comes back with a piece containing lots and lots of
tones in the high register. "Be careful with those!", said Feldman, "there's a
lot of 20th century affection associated with the high register". So, away the
student went again. One week later he returned, this time with a piece of music
that contained lots of tones in the bass. Again, Feldman told him to watch out,
that the bass can easily swamp all the other sounds going on. At this point the
exasperated student protested - how was he going to write a piece of music if
all of his approaches were wrong? At this point the composer grabbed him by the
tie (it was still at a time when men wore ties, apparently) and shouted *"alles
zusammen!*

What the student was failing to grasp is the difference between the tools and
the method. In the context of a single piece of music or a program, the tools
are essentially static. They are fixed in terms of what they can produce when
used correctly. Method on the other had can be a little more dynamic. In the
context of music, method is the way that we move from note to note. In
programming it's the way that we structure the interaction between the
individual code components.

Over the past few years, I've moved from writing scores in the Lilypond
language by directly specifying the musical and markup content in the source
directly, to using python APIs as a way to generate Lilypond scores. At some
point along the way, I convinced myself that the paradigm of Object Oriented
Programming was the holy grail in terms of writing code to generate music. I'm
starting to wonder if this might be a bit short sighted. The object oriented
paradigm is good for programs where you need to manage state, in this way it is
similar to (or perhaps a descendant of) imperative and procedural programming.
The question is - do we really need to manage that much state when we are
thinking musically? Probably not - music is pretty much a continual flow of
specific sounds. This idea of directing flow without necessarily worrying about
managing state is a key component of functional programming.


## Functional programming in python

The [python docs](https://docs.python.org/3/howto/functional.html) present a
really useful how-to guide that covers the main features related to functional
programming that are offered by python.

As stated a minute ago, functional programming is all about flow and combining
streams of data, rather than aggregating state. Python provides the iter
function as a way to turn a list into a generator:

```
# define two pitchclass sets
cionian = [0, 2, 4, 5, 7, 9, 11]

# use iterators to step through
it = iter(cionian)

>>> next(it)
0
>>> next(it)
2
>>> next(it)
4
```


## List comprehensions and Generators

```
# define fsmaj harmony
fsmaj = [6, 10, 1, 5]

mygenexpr = ((x, y) for x in cionian for y in fsmaj)

# a list comprehension returns the whole list
>>> [(x, y) for x in cionian for y in fsmaj]
[(0, 6), (0, 10), (0, 1), (0, 5), (2, 6), (2, 10), (2, 1), (2, 5), (4, 6),
(4, 10), (4, 1), (4, 5), (5, 6), (5, 10), (5, 1), (5, 5), (7, 6), (7, 10),
(7, 1), (7, 5), (9, 6), (9, 10), (9, 1), (9, 5), (11, 6), (11, 10), (11, 1),
(11, 5)]

# a generator expression allows us to access one element at a time
>>> mygen = ((x, y) for x in cionian for y in fsmaj)
>>> next(mygen)
(0, 6)
>>> next(mygen)
(0, 10)
>>> next(mygen)
(0, 1)

```

Python also has some useful libraries and inbuilt functions that make writing
generators and list comprehensions quite easy. By the way, it's okay to have a
little state here and there, remember ... "alles zusammen!"

```
# func.py: blend a cionian scale with fsmajor7 harmony in a functional way
# usage: /usr/bin/python3 func.py

from itertools import cycle as cycle

def cyclescale(scale):
    # cycles through values in a scale
    return cycle(scale)

def cyclegen(genexpr):
    # cycles through elements in a genexpr
    return cycle(genexpr)

# some constants to feed the generators
cioniandict = { "c": 0, "d": 2, "e": 4, "f": 5, "g": 7, "a": 9, "b": 11 }
cleaves, dleaves, eleaves, fleaves, gleaves, aleaves, bleaves = [], [], [], \
        [], [], [], []

def zipcycle(combicycle, scalecycle):
    for i in range(0, 50):
        item = next(combicycle)
        if item[0] == cioniandict["c"]:
            cleaves.append(item)
        if item[0] == cioniandict["d"]:
            dleaves.append(item)
        if item[0] == cioniandict["e"]:
            eleaves.append(item)
        if item[0] == cioniandict["f"]:
            fleaves.append(item)
        if item[0] == cioniandict["g"]:
            gleaves.append(item)
        if item[0] == cioniandict["a"]:
            aleaves.append(item)
        if item[0] == cioniandict["b"]:
            bleaves.append(item)

if __name__ == '__main__':
    cionian = [0, 2, 4, 5, 7, 9, 11]
    fsmaj = [6, 10, 1, 5]
    mygenexpr = ((x, y) for x in cionian for y in fsmaj)
    cioncycle = cyclescale(cionian)
    cfscycle = cyclegen(mygenexpr)
    zipcycle(cfscycle, cioncycle)
    cadgen = ((x,y,z) for x in cleaves for y in aleaves for z in dleaves)
    dfegen = ((x,y,z) for x in dleaves for y in fleaves for z in eleaves)
    efbgen = ((x,y,z) for x in eleaves for y in fleaves for z in bleaves)
    gbcgen = ((x,y,z) for x in gleaves for y in bleaves for z in cleaves)
    for i in range(0, 10):
        print(next(cadgen), next(dfegen), next(efbgen), next(gbcgen))
```

If we run this program in a python3 virtual environment, we get the following
output. 
```
(genv)<my@gen>$ python func.py
((0, 6), (9, 6), (2, 6)) ((2, 6), (5, 6), (4, 6)) ((4, 6), (5, 6), (11, 6))
((7, 6), (11, 6), (0, 6))
((0, 6), (9, 6), (2, 10)) ((2, 6), (5, 6), (4, 10)) ((4, 6), (5, 6), (11, 10))
((7, 6), (11, 6), (0, 10))
((0, 6), (9, 6), (2, 1)) ((2, 6), (5, 6), (4, 1)) ((4, 6), (5, 6), (11, 1))
((7, 6), (11, 6), (0, 1))
((0, 6), (9, 6), (2, 5)) ((2, 6), (5, 6), (4, 5)) ((4, 6), (5, 6), (11, 5))
((7, 6), (11, 6), (0, 5))
((0, 6), (9, 6), (2, 6)) ((2, 6), (5, 6), (4, 6)) ((4, 6), (5, 10), (11, 6))
((7, 6), (11, 6), (0, 6))
((0, 6), (9, 6), (2, 10)) ((2, 6), (5, 6), (4, 10)) ((4, 6), (5, 10), (11, 10))
((7, 6), (11, 6), (0, 10))
((0, 6), (9, 6), (2, 1)) ((2, 6), (5, 6), (4, 1)) ((4, 6), (5, 10), (11, 1))
((7, 6), (11, 6), (0, 1))
((0, 6), (9, 6), (2, 5)) ((2, 6), (5, 6), (4, 5)) ((4, 6), (5, 10), (11, 5))
((7, 6), (11, 6), (0, 5))
((0, 6), (9, 10), (2, 6)) ((2, 6), (5, 10), (4, 6)) ((4, 6), (5, 1), (11, 6))
((7, 6), (11, 10), (0, 6))
((0, 6), (9, 10), (2, 10)) ((2, 6), (5, 10), (4, 10)) ((4, 6), (5, 1), (11,
10)) ((7, 6), (11, 10), (0, 10))

```
