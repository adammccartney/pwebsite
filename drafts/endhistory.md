---
title: "Cowboys and bobsleds"
date: 2023-02-03T09:44:16+01:00
draft: false

---

Contributing in an perfect world
================================

My work over the past number of years has taken place in university
IT departments, most recently as a software engineer for cloud native
research applications. In the process I've learned a lot about
infrastructure and deployment and come to reflect a bit about working
collaboratively on software projects.

I reckon that University IT shares many of qualities with the wild west.
To the people in charge at the university, Digital technology appears
as some vast frontier, filled with promise and seemingly limitless
possibility. What's more, it's a pretty great excuse to dip into one
of the huge troughs of cash made available by the EU for digitization
projects. I'm not really sure what the purpose of these big top-down
cash infusions are, but I am pretty sure that they seem to attract
their fair share of questionably groomed frontiersmen (present company
included).

I've met true cowboys, naturally talented developers who understand all
the moving parts of their working environment. They introduced version
control and various types of bug tracker. They haven't quite yet managed
to get teamwork really rolling (they still plead with their coworkers
to actually use git). Then there are gunslingers, they've been rolling
out applications with the same web framework for the past 10 years.
They're so quick that they've usually moved on to the next project by
the time you've checked out the first repository. Of course there is
no documentation, comments in the code or readable commits, because
who the hell has time for any of that boring stuff. It's all obvious
anyway! The preacher is another type that rolls around the office with
nothing in particular to do. They write manifesto like emails and try to
encourage their coworkers to lead better lives and actually write some
documentation for once. The gambler uses the production server for all
their development. Life is only interesting when the stakes are high.

With all of these characters knocking about in one form or another, it's
equally easy to imagine yourself happily beavering away or reaching for
the nearest telephone to call a bewilderment hotline. In the course of
work, people are left to their own devices for the most part. So if
you're a bit of a self-starter and not afraid of having to tune out a
bit of noise from time to time, it's a great place to pick up new skills
and try out new technologies. Of course there are some downsides, the
fact that the data center in a non-software oriented company is usually
considered a cost center rather than a place that actually produces
value for the organization, many activities often take place as some
form of afterthought.

Lately I've found myself wondering a bit about how contribution is
supposed to work in environments like the university data center.
Perhaps we should look to projects like [linux](https://kernel.org),
[qemu](https://qemu.org) or [git](https://git-scm.com), who all have
clearly defined and well structured contribution guidelines. The
projects are maintained by large, distributed teams of developers. Each
of these developers might have their own motivations for contributing,
perhaps the company that they work for needs a feature to be pushed
upstream. The repositories themselves are relatively homogeneous and the
problem domain tends to be well defined, or broken down into a series of
sub-domains whenever necessary.




# A history of histories

The documentation and cleanup efforts on the pacman repository in late 2022 and
early 2023 started by using the branching model suggested by  Christian Veigl in the
[Development Process](https://colab.tuwien.ac.at/display/ADLS/Development+Process)
wiki page. In that document it is suggested that the team follow the
[Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) model.
The blog post describing gitflow is well written and worth a read. However, as
the author himself notes, it was written over 10 years ago for a specific type 
of software -- desktop or mobile applications that need to maintain releases for
multiple architectures and platforms. Web applications by contrast are
continuously deployed and have the luxury of targeting a single architecture and
platform. As pacman is clearly a web application specifically designed to run on
Kubernetes, it makes more sense to follow a pattern similar to the one explained
in [Github Flow](https://docs.github.com/en/get-started/quickstart/github-flow).

# Branching and merging 

In a nutshell, the pattern advocated by Github Flow revolves around short lived
feature branches that are merged into main once they have been reviewed by a
maintainer during a merge. Essential reading for understanding how branching and
merging can be found in [section 3.2](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)
of the git-scm book.

# History is not over 

If the last few years have taught us anything, it's that the assumption that we've
reached the end of history is incorrect. Although that comment is mostly
directed at world history and the assumptions made by western democracies at the
end of the soviet era, it represents a true fact about the world. We want and
need all the practice we can get being more conscious and aware of our actions
at any given moment. One of the most enjoyable coincidences of using git is that 
it gives you an opportunity to do just that -- you (literally) write history!
With that in mind, there are a few common sense guides to actually writing git
commits that I find very useful, both are blog posts. 

The first is by [Greg Hurrel](https://wincent.com/blog/commit-messages) where he
does an analysis of his own git usage and reviews the types of commits that he
has himself made over the years. 

The second is a post by lbrady titled [Writing better commit messages](http://lbrandy.com/blog/2009/03/writing-better-commit-messages/)

While those blog posts offer a good starting point and provide many useful
insights into the practice of writing git commit messages, it's also essential
to familiarize yourself with the tools required for some of the more involved
git tasks like [Rewriting history](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)
or using [Git rebase](https://git-rebase.io/) to consolidate your feature branch
before opening up a merge request.
