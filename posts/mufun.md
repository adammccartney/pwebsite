title: mufun
date: 2023-07-02 09:21
tags: functional programming, music, grammars, parsing
---

I posted [elsewhere](/programming/objectsandmusic) about how programming
paradigms might influence the music that we write. The main slant
of the post was a naive exploration of some simple ideas related to
functional programming. The basic idea that motivated the post was a
basic curiosity about the implications of thinking about a melody or
musical voice as an unfolding stream. To be precise, I'm talking here
about information streams that happen at sub-audio rate. In other words,
control streams that contain information about what a human
(or a very funky marmot) would perceive as melody or rhythm.

To talk about music at audio rate requires another frame of reference,
different data structures and different paradigms. Now the color of a
tone, or in other words, the spectral content of a sound appears to be
more of a still image. It's like a painting of a single flower. Melody
is more like a walk in the garden. The architect Andrea Palladio had a
very interesting concept of harmony. His idea was that harmony was not
down to the use of any specific set of proportions in a design, but was
something that arises from the interaction between the many different
sets.

But hang on, I thought we were talking about melody? Yeah, well
depending on who you talk to and what century they are coming from,
they might be of the opinion that melody is like taking a walk through
a certain harmonic space. Okay, okay, so what does this have to do with
functional programming?

It turns out that even some of the most rudimentary concepts that relate to
iterating through a stream of objects can prove quite useful. The tools that I
want to play around with are generator functions in python.

## Infinite loops 

As far as I understand, a generator function is a bit like the poor
man's coroutine. Or it's like your friend at the bar who always
tells the same story after his 3rd pint of stout. You've told him a
bunch of times that you've heard it before, but he's not really amenable
to input at that hour of the night and hey, it's a funny story so why
not listen to it again. 

As you have gleaned from that sparkling analogy, a generator will plod
through whatever it's supposed to. It's like a friend after three pints
too - it still behaves with more than a modicum of good taste and humor,
it will even pause the story while you run to the bathroom!

This idea of pausing the story is essential to the generator function.
Python has the very useful `yield` statement that enables a programmer
to pause any function, return the current value and then resume the
function again at the same place later. Another way to think about
them is that generators give you the ability to construct functions
that behave like iterators. Using some functions from the `itertools`
library, it is quite easy to make a looping cycle out of any list of
objects. Once we have a list that behaves as an if it were an infinite
sequence of the same values, we've got an interesting way to model a
specific chunk of any given melody.

The code segment below shows a function that combines two iterators
(one for pitches, one for rhythms) so that they will produce strings
containing notes in the `lilypond` language. The second function is
used as a type of wrapper to determine how many notes should be in the
sequence.


```python
import itertools
from typing import Iterable

def inf_sequencer(notes, rhythm) -> map:
    "Musical sequence generator"
    inf_notes = itertools.cycle(notes)
    inf_rhythm = itertools.cycle(rhythm)
    return map(lambda a, b: f"{a}{b}", inf_notes, inf_rhythm)

def genchunk(note_sequence: map, nnotes: int) -> str:
    "Generate music containing n notes. Return as string."
    result = ""
    while(nnotes):
        result = result + next(note_sequence) + " "
        nnotes -= 1
    return result
```

## Getting your ducks in a row

So, now that we've got a way to create arbitrary melodic chunks that repeat
forever. We'd like to make many of them, each containing their own
unique set of notes that would be specific to whatever proportions we want to
convey at a particular time (remember the architect?). We'd then like to move
between our generator functions to give the impression of harmonic motion.
We're just weaving little chunks of melody together.

```python
def weaver(sequences: Iterable[map], isorhythm: list[int], repetitions: int):
    """Weaves a series of sequences together according to an isoryhtm.

    A sequence 'S_i' will yield the note 'N_i'.

    A complete isorythm is the sum of the members of the isoryhthm list,
    this represents a single cycle. The number of repitions represents the
    number of times the cycle will be repeated."""
    result = ""
    while(repitions):
        for seq, repeats in zip(sequences, isorhythm):
            chunk = genchunk(seq, repeats)
            result = result + chunk 
        repitions -= 1
    return result
```

## Magic numbers

At some point, at least in this example, we're going to want to
hard-code some actual music. We need to tell the program what we want it
to generate. We do this by specifying the pitches and notes that we will
use as input to the various musical chunks that we are going to corral
into a melody.

Full disclaimer, there is a bit of magic going on here. I'm hard coding
a set of integers called `iso` this refers to the fact that the set is
going to be the [isorhythm](https://en.wikipedia.org/wiki/Isorhythm) of
the melody, further more it exhibits a special type of characteristic:
the [euclidean rhythm](https://en.wikipedia.org/wiki/Euclidean_rhythm).
The particular numbers that I've chosen here are

As mentioned above, we're targeting [lilypond](https://lilypond.org) as
an output format. With that in mind, we'll create a template that
we can use for our score.


```python
def create_score():
    "Hard code a score an create a format string"
    iso = [3, 3, 4, 3, 3]
    fis_seq = inf_sequencer(["fis''", "e''", "dis''", "c''"], [8])
    cseq = inf_sequencer(["fis''", "e''", "dis''", "c''"], [8])
    fis_seq = inf_sequencer(["cis''", "c''", "ais'", "a'"], [8])
    aseq = inf_sequencer(["gis'", "fis'", "e'", "dis'"], [8])
    sequences = [cseq, cseq, fis_seq, fis_seq, aseq]
    music = weaver(sequences, iso, repetitions=4)
    result = format_score(music)
    return result

def format_score(music):
    "Score with single staff, for example"
    header = r'''\version "2.22.2"
\language "deutsch"

\header 
{ 
        tagline = "mufun etude no. 1"
        composer = ""
}
'''
    paper = """
#(set! paper-alist (cons '("my size" . (cons (* 5 in) (* 3.5 in))) paper-alist))

\\paper 
{
        #(set-paper-size "my size")
}
"""
    layout = "\\layout{}\n" 
    score_begin = "\\score \n{\n"
    staff = f'''\\new Staff \n{{\n{music}\n}}\n'''
    score_end = f"{layout}\n}} % score"
    result = f"""{header}{paper}{score_begin}{staff}{score_end}"""
    return result


mufun_etude_no1 = create_score()
print(mufun_etude_no1)
```

This will print the lilypond score to stdout. 

```lilypond
\version "2.22.2"
\language "deutsch"

\header 
{ 
        tagline = "mufun etude no. 1"
        composer = ""
}

#(set! paper-alist (cons '("my size" . (cons (* 5 in) (* 3.5 in))) paper-alist))

\paper 
{
        #(set-paper-size "my size")
}
\score 
{
\new Staff 
{
fis''8 e''8 dis''8 c''8 fis''8 e''8 cis''8 c''8 ais'8 a'8 cis''8 c''8 ais'8 gis'8 fis'8 e'8 dis''8 c''8 fis''8 e''8 dis''8 c''8 a'8 cis''8 c''8 ais'8 a'8 cis''8 c''8 dis'8 gis'8 fis'8 fis''8 e''8 dis''8 c''8 fis''8 e''8 ais'8 a'8 cis''8 c''8 ais'8 a'8 cis''8 e'8 dis'8 gis'8 dis''8 c''8 fis''8 e''8 dis''8 c''8 c''8 ais'8 a'8 cis''8 c''8 ais'8 a'8 fis'8 e'8 dis'8 
}
\layout{}

} % score
```

We can compile the lilypond score to generate the following notation.

{{< figure src="/images/mufun/etude1.png" width="360" height="360" >}}

## Remind yourself to be human

At the time of writing this article, there a lot of hype about
artificial intelligence. Many people are pondering the impact that it
will have on intellectual activities carried out by humans. It's quite
amazing to play around with some of these new toys like chat GPT and it
is also quite easy to get wrapped up in the hype. I'm still trying to
figure out if it's the presence of this types of invention that has me
trying to invent my own new method for creating music that is somehow
clean, happens easily and at the touch of a button. My suspicion is that
I'm not the first artist who has looked to get away murder in this way.
Should we fear replacement by a new cleaner model of creation based on
machine intelligence? The birds and the whales have been giving us a run
for our musical money for the past few hundred thousand years at least,
and if that is anything to go by, there is still plenty of space for
human music.

