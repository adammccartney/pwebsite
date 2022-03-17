## origins

marana is a word in the Irish language that can be translated as meditation. Or
more rightly put, it's a word that I found when looking for a translation of
the word meditation. As an Irishman myself, I can confess to probably being too
mad to really meditate. It's probably closer to some sort of rumination that feels 
more familiar. Anyway, marana is a word that sort of emerged while speaking with 
two Irish speakers who live in the Waterford area. I settled on it because it
has a nice ring to it. At the time (in 2020) I was looking for a title for
a short piece of orchestral music for a project with the [CMC](https://www.cmc.ie/)
and the [NSO](https://www.nso.ie/). marana seemed like a good name for a
short piece. I think it's not unheard of to sometimes call a short work for
orchestra meditation. I wonder if there are any pieces by Irish composer's
called ruminations for orchestra?

In the meantime of course the covid pandemic happened and the project was
postponed and postponed again. In the meantime I was working on the soundtrack
for [Becoming Arctic](https://filmfreeway.com/BecomingArctic) and 
[rill (erosion)](https://github.com/adammccartney/rill/), a piece that formed
part of the [rotting sounds](https://rottingsounds.org/) artistic research
project. Although I've been using [lilypond](https://lilypond.org/) to notate
music for some time, and had started using python scripts as a way to generate
some of the lilypond music syntax more quickly, for these two pieces (rill and
becoming arctic) I started to use the [abjad](https://abjad.github.io) API as a
way to interface with lilypond.

## The destination and the journey
+ thought it would be possible to start modelling really cool algorithmic stuff
  musically - took alot longer than expected to master the basics
+ the journey had a lot more to do with discovering what type of architecture
  and approaches suited my particular style of thinking and way of working 
+ so where am I going now ... I honestly don't know

### straight lilypond, using frescobaldi IDE, acessible scripts
+ handwritten music
+ basic scripting to transpose etc.
+ search and replace with regex

### scripting simple solutions in python - format strings
+ iterating over arrays to populate format strings
+ format strings essentially had a predifined rhythmic pattern

### the abjad api 
+ the lowest level api in abjad is really fantastic
+ higher level abstractions and score organization feels foreign


## Designing a custom approach
Bjarne Stroustrup makes a good point in his
[book](https://www.stroustrup.com/programming.html) when talking about
interfacing with third party code. He remarks that ideally, we would like to
keep any code we write around for as long as possible, and so we want to keep
dependencies to a minimum. I've tried to keep this in mind when working on
marana. abjad is a really useful library that is carefully and lovingly
maintained. At the same time, it is a big complex API that I didn't write and
don't fully understand, so I want to keep my reliance on it as a sort of a
swiss army knife solution to a minimum. What I do want is to essentially cherry
pick a couple of functions and classes. 

## Pitch selectors
+ 


