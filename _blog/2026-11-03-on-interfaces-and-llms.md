---
layout: blog-post
title: "Thoughts on the Role of Software Interfaces in the LLM context"
date: "2026-11-03"
categories: [programming, science, software engineering, llms]
excerpt: "Designing good interfaces for software, both external and internal, is hard."
---

Designing good interfaces for software, both external and internal, is
hard.  By 'external', I mean the mechanisms by which users will
compile/build/link (if needed) and run the software, how they will
interact with it, and how it will interoperate with other software
systems.[^1] By 'internal', I
mean the software architecture, the programming interfaces and
abstractions which delineate subcomponents of the code to enable
reuse, de-duplication, understanding, and reasoning.
A risk with significant LLM use for software
engineering is that badly designed interfaces are reinforced; rather
than seeking more illuminating interface designs, the LLM papers
over the cracks, burning through extra energy to find, and re-find,
ways to achieve a stated goal. The result may be both inefficient in
its generation ('tokens burned') and inefficient in its final generated
form, e.g., in terms of computational cost or maintenance cost
(code bloat and obfuscation). Good interfaces instead aid
understanding, expose the essential concepts behind a piece of
software in ways that stimulate new ideas and approaches, help avoid
misunderstandings and bugs, and reduce effort in the code development
process.

All such benefits can be harvested by both humans *and*
computers, and not just LLMs. Analytical processes like static
analysis tools and compilers can also benefit from abstractions that
expose more information about a program and provide increased
modularisation, which helps with scalability.


<p class="callout">Good interfaces communicate intent and ideas.</p>


The role of documentation is also important here and has a non-trivial
interaction with software design. Good documentation can lessen some
of the worst effects of design weaknesses, and poor documentation can
increase the friction and effort in making use of even a good
interface. Intuitively, documentation should have a role to play in improved
LLM performance as well. One study looking at the relationship
between documentation and the ability to generate
unit tests did not yield a strong correlation <a class="cite" id="cite-1" href="#ref-1">[1]</a> but later studies (in the context of Java)
 showed a considerable improvement in the ability to generate test oracles when documentation was included
<a class="cite" id="cite-2" href="#ref-2">[2]</a>.
I do not have time to dig
deeper into the evidence here, but my experience, and those of some of my
colleagues, is that having good design documentation seems to benefit
LLMs (improved quality and reduced time to solution).

In the context of external interfaces, my own experience has been that
LLMs can be very useful for working out how to get complex software
stacks working and building, e.g., running scientific models that
require a diversity of libraries, additional software, and HPC
environments, with complex non-standard configuration systems. This
appears to be a big win, offloading some human effort to the machine,
at some additional energy cost downstream. In the computational
science context, where a lot of time can be spent getting the models
of other groups running, I think there can be a considerable productivity
improvement here, especially in exploratory context. Removing the
barriers around the building processes, and external interfaces, can
even mean that more models can be explored and investigated from others' work.

However, at the internal, software level, I've found that LLMs
(including at the frontier as of writing in October 2026) steer
towards writing more and more code rather than trying to find good
abstractions and interfaces. I usually find things work better if I
design the architecture and interfaces largely myself, do the deep
thinking about the design concepts and ideas, and then have the LLM
assist in writing the 'inside' code, rather than the other way around.
One could compare this with the observation that LLMs do not invent
new 'mathematical objects' (i.e., abstractions!) in the way that
mathematicians do.

Some aspects of this tension arise in the recent discussions around AI
autoformalisation of mathematics in interactive theorem provers (see,
e.g.,
<a class="cite" id="cite-3" href="#ref-3">[3]</a>).
The authors (Jeremy Avigad, Kevin Buzzard, Johan Commelin, Rémy
Degenne, Kim Morrison, Oliver Nash and Adam Topaz) posit that

> Knowledge isn’t worth having until it contributes to our
> understanding; the value of a formalization comes from our ability to
> use and interact with the data.
>
> Jeremy Avigad et al.
> {: .quote-author}

I believe the interface provided by
any proof code seriously affects our ability to use and interact with
it, and to grow our understanding.  They go on to say:

> Good formal
> libraries will enable the positive vision we have for the future of
> mathematical research.
>
> Jeremy Avigad et al.
> {: .quote-author}

The "good" here is exactly those interface
designs that enable human understanding and flexible reuse of
existing ideas (proofs or code--which are really [the same thing](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence)).

Unmesh Joshi and Martin Fowler talked about issues around software
design and LLMs in a curated conversation in 2025: [LLMs and Building
Abstractions](https://martinfowler.com/articles/convo-llm-abstractions.html).
There is a lot of great discussion here which I largely agree with.[^2] The conversation
orbits around ideas of how the programming process shapes the software
in an iterative process that is hard to achieve with an 'upfront design'.
A quote:

> Programming isn't just typing coding
> syntax that computers can understand and execute; it's shaping a
> solution. We slice the problem into focused pieces, bind related data
> and behaviour together, and—crucially—choose names that expose
> intent.
>
> Unmesh Joshi
> {: .quote-author}

This takes us back to good interface design and how
it emerges from the process of writing the
code ourselves, where continued iteration helps us to form ideas
into something coherent and understandable by others. Domain-specific
terminology may shape our interfaces and abstractions explicitly.
Another long quote:

> I think of programming as having two deeply interwoven activities.
>
> The first of these is Discovering and Stabilizing Abstractions.
>
> This is creative in
> nature-the part where we explore multiple options, experiment, and
> slowly converge on stable abstractions. In this activity, we observe
> coding patterns, decide what is common, and identify what might vary
> in the future. We then choose language constructs that arrange these
> common elements in a way that makes future variation easier.
>
> Once abstractions are stable—well-named, well-tested, and
> well-understood—we Apply Stable Abstractions to implement new use
> cases or variations. In Domain-Driven Design (DDD) terms, this is
> where we work with the domain model: a set of named abstractions that
> reflect the business domain and carry precise meaning.
>
> Unmesh Joshi
> {: .quote-author}

This points to the key activities in defining our internal software
interfaces. One can imagine trying to explicitly codify this in
the software development process, instigating first a phase of
discovery where one or more programmers or LLMs explores a few different
designs and ideas, followed by a stabilisation process in which consensus
around a single approach is built. The resulting stabilised abstractions
can then give LLMs and humans a stronger set of
building blocks (a "vocabulary") to work with, reducing their
 overall efforts. But getting to this point requires thought and iteration.

A last germane quote is from Guy Steele's 1998 OOPLSA keynote ["Growing
a language"](https://www.youtube.com/watch?v=_ahvzDzKdB0):

> [..] a good programmer in these times does not just write programs. A good programmer builds a working vocabulary. In other words, a good programmer does language design, though not from scratch, but by building on the frame of a base language.
>
> Guy Steele
> {: .quote-author}

Part of designing the software interfaces in our code is exactly this
process of growing a language: an internal, embedded, domain-specific
language capturing our intent in the code. If we let LLMs do all
of this work without our involvement,
then LLMs will make choices for us that will almost
certainly differ to what comes out of our own iterated thinking.
Simply reviewing the output from LLMs is unlikely to lead to
significant changes in the overall design once code has been written
(something like the effect of a 'status quo bias', falling into a low-effort
'rubber stamping' behaviour; Unmesh mentions this too, contrasting
pair programming vs. passive PR reviews). This is not to say that
we must not use LLMs in this process, but my caution would be in
letting the LLMs make all the design decisions
without the human-in-the-loop to provide their knowledge, context,
and expertise of the problem, and their overall aesthetic and technical
design sense.

By giving serious consideration to software
interfaces, both the internal and external, the end result
is software that overall requires less effort to understand, use, maintain,
 and extend, for both humans and machines.
 For LLMs, more effort equates to more electricity consumed, and
[more data centre demand](https://www.bloomberg.com/news/articles/2026-10-28/us-data-center-buildout-risks-erasing-years-of-climate-progress?accessToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb3VyY2UiOiJTdWJzY3JpYmVyR2lmdGVkQXJ0aWNsZSIsImlhdCI6MTc5MzIxODQ4MywiZXhwIjoxNzkzODIzMjgzLCJhcnRpY2xlSWQiOiJUTk03WTFLSVAzSVAwMCIsImJjb25uZWN0SWQiOiJGM0VENDU5NTZFRjA0QjY5QTI0NTVBNTYxRDkyNkY5NiJ9.vaYGVNos-PgwrFAeFWxa9-gyGHRxRihCe_on05i2B3A&leadSource=article-gifting), the growth of which should be a serious concern for us all.

Now actually how to design good interfaces is a huge topic and there
is a lot that could be said here (there are lots of
books on designing software architecture), so I'll leave this topic
for another blog post perhaps. That said, a few thoughts were bashing around
my head in the preparation of this blog post so I'll finish with them
as a few non-exhaustive thoughts:

- Be intentional about interface design: build in time in the development
process for discovering abstractions and then reviewing/stabilsing abstractions;

- "Make interfaces easy to use correctly and hard to use incorrectly" <a class="cite" id="cite-4" href="#ref-4">[4]</a>;

- Exploit types if available to encode meaning and then enforce correct behaviour;

- A good abstraction should be about more than just avoiding duplication <a class="cite" id="cite-5" href="#ref-5">[5]</a>;

- Choose naming that reflects the domain as much as possible to build
up a 'ubiquitous language' <a class="cite" id="cite-6" href="#ref-6">[6]</a>;

- Write design documentation, including what are the main values, principles, and goals within the design.

<p style='color:grey'>(No AI was used in the writing of this blog post).</p>

## References

<ol class="references">
  <li id="ref-1">William Macke and Michael Dean Doyle. <a href="https://aclanthology.org/2024.findings-naacl.66/">Testing the effect of code documentation on large language model code understanding</a>. In <em>Findings of the Association for Computational Linguistics: NAACL 2024</em>, 2024. <a href="#cite-1" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-2">Soneya Binta Hossain, Raygan Taylor and Matthew Dwyer. <a href="https://dl.acm.org/doi/full/10.1145/3729354">Doc2OracLL: Investigating the Impact of Documentation on LLM-Based Test Oracle Generation</a>. <em>Proceedings of the ACM on Software Engineering</em>, 2(FSE), 2025. <a href="#cite-2" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-3">Jeremy Avigad, Kevin Buzzard, Johan Commelin, Rémy Degenne, Kim Morrison, Oliver Nash and Adam Topaz. <a href="https://xenaproject.wordpress.com/2026/10/16/how-to-formalize-all-of-mathematics/">How to Formalize All of Mathematics</a>. <em>Xena Project blog</em>, October 2026. <a href="#cite-3" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-4">Scott Meyers. <a href="https://martinfowler.com/ieeeSoftware/designGuideline.pdf">The Most Important Design Guideline?</a> <em>IEEE Software</em>, 21(4), 2004. <a href="#cite-4" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-5">David R. MacIver. <a href="https://drmaciver.com/notebook/2024/01/writing-good-programming-abstractions/">Writing good programming abstractions</a>. Blog post, January 2024. <a href="#cite-5" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-6">Martin Fowler. <a href="https://martinfowler.com/bliki/DomainDrivenDesign.html">Domain Driven Design</a>. <em>martinfowler.com</em>, April 2020. <a href="#cite-6" class="cite-back" title="Back to text">↩</a></li>
</ol>

[^1]: I am primarily not thinking about GUIs, although the same thinking can be applied there.

[^2]: Though a point is made that "All the boilerplate required just to get the software running is all the accidental complexity. I think LLMs are good at reducing accidental complexity." They give the example of writing some code to connect two systems: "Need a Spring Boot service that talks to Kafka and logs with OpenTelemetry? An LLM can spit out a working template in seconds." But in this example the accidental complexity is not reduced; the complexity is still there, it was just outsourced. Any deficiencies in the interfaces (I am not claiming there are any in this example; I do not know these systems) still needs to be worked around by the LLM, and then the resulting code is still present and will need reviewing and reusing by others in the future.
