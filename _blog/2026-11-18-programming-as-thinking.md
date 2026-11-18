---
layout: blog-post
title: "Writing is thinking, and programming is thinking too."
date: "2026-11-18"
categories: [programming, writing, llms]
excerpt: "If writing is thinking, then so is programming (and so is making slides). Over reliance on AIs can therefore rob us of the chance to think."
---

![A laptop and notebook at night](/assets/blog-thinking.png){: .post-banner}

The 'bureau' where I did lots of thinking as a postdoc (circa 2014)
Based on an old photo taken on an old smartphone, that GPT-6 sharpened
up.
{: .post-caption}

Image by Dominic Orchard, licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
{: .post-credit}


A colleague recently pointed me at this lovely article in the
Economist, titled _AI often makes writing worse. (Even if it makes it
better)_ <a class="cite" id="cite-1" href="#ref-1">[1]</a>. The article includes the following argument:

> Real writing is not writing at all. It is thinking; specifically it
> is thinking: “What do I think?”
>
> The Economist
> {: .quote-author}

It goes on to quote Prof. Emma Smith (University of Oxford):"Often, 'you only really know what you think by writing it'". This reminded me of two other quotes which I have pinned in the
introduction page of a "team" repository that I share with all my students and postdocs:

> If you're thinking without writing, you only think you're
> thinking. [...] Everyone thinks they think. If you don't write down
> your thoughts, you are fooling yourself.
>
> Leslie Lamport, creator of LaTeX (a document preparation system)
> {: .quote-author}

> Writing is Nature's way of showing you how sloppy your thinking is.
>
> Dick Guindon, cartoonist
> {: .quote-author}

This also aligns with the advice Simon Peyton Jones gives, that
as soon as you have an idea, you should start writing the paper about it <a class="cite" id="cite-2" href="#ref-2">[2]</a>.
Why? Because it forces you to confront what you don't yet understand and
what evidence is needed. Writing opens up a way to have a dialogue
with others who can critique and collaborate on the idea.

In all of these quotes, people are tapping into the idea that many
people have discovered and discussed<a class="cite" id="cite-3" href="#ref-3">[3]</a><a class="cite" id="cite-4" href="#ref-4">[4]</a><a class="cite" id="cite-5" href="#ref-5">[5]</a><a class="cite" id="cite-6" href="#ref-6">[6]</a>, that the act of writing gives
you a chance to really think about an idea, problem, or argument.
Writing helps you generate new ideas, deepens your exploration of the problem
 or ideas, and helps you to understand how to evaluate it.

Going back to the Economist article, their point is that if we give
writing over to AI we lose that opportunity to think for ourselves. I
know some find it daunting, but I relish starting with an
empty page and a fresh idea because I know that is where the action
happens! Getting it down on paper helps my brain to think it through rather
than "fooling myself" (Lamport) that I understand the idea well
enough. And if I get stuck, I can always switch things up and try
some different writing strategies. (I have written [a whole list of
them](https://dorchard.github.io/advice/writing-strategies.html), to help me and my students;
useful when hitting writer's block I hope!)

If writing is thinking, then I believe same applies also to _programming_. 
I do not think this will be a controversial point (at least not
amongst my computer science colleagues) but in the current
AI summer, this idea seems to be getting lost, and can be missed
out by those without training or a background in programming.

Programming is thinking
{: .callout}

We are in a world
where AI agents are writing large amounts of code, and people are wondering
whether software engineering is a dying art with code increasingly
becoming just an opaque box we do not need to, or indeed cannot reasonably, inspect.
But just as writing is thinking, _programming is thinking_ too! At least,
it can be. Many times I've grappled with a problem
or idea, from a variety of domains, by writing code about it. 
I often tell undergraduate students to
'implement their mathematics' as a way of helping them to get a better
intuitive grasp of the ideas. By programming some concept or theory, the student gains a deeper appreciation for something abstract. A germane quote:

> People have said you don’t understand something until you’ve taught
> it in a class. The truth is you don’t really understand something
> until you’ve taught it to a computer, until you’ve been able to
> program it.
>
> George Forsythe
> {: .quote-author}

<span style='color:#888'>(I couldn't find the origin for the quote but it is mentioned
in a _Communications of the ACM_ interview with Donald Knuth which touches on similar ideas <a class="cite" id="cite-7" href="#ref-7">[7]</a>.)</span>

The point is that computers (in their traditional way of working)
are very stupid. To 'explain an idea to them'
you have to spell things out, in code, in considerable detail.
But doing so makes sure that you yourself understand the idea. And then
you have an object 'in your hand' which you can inspect and probe, by running
it with particular inputs, or other kinds of analysis. If we just automatically
turn to an LLM to do our programming work we miss out on the opportunity
to actually explore a problem or an idea. Not all programming is like
this, but certainly some is. This fits into broader notion of 'computational thinking' <a class="cite" id="cite-8" href="#ref-8">[8]</a> which was big about 10-15 years ago,
where we leverage ideas from computing as analytical techniques to
help solve problems and design systems.

So writing is thinking, and programming is thinking,
and I think that a similar argument could be made for other kinds of
'content production'. Perhaps a bit more of a parochial example,
but for similar reasoning, I propose that:

Writing slides is thinking
{: .callout}

I personally find writing slides for talks and lectures to be a hard
slog, and it is a significant component of my job. But the process of
writing those slides (which can take me as long as a day for a one hour
talk or lecture) gives me a chance to think through what the key messages
are that I want to get across are, how I want to say it, in what order,
what story I want to tell, and examples to include. The deep work
of staring at blank slides, moving bits of text and pictures around,
is a time when my brain is preparing all the groundwork for the
actual spoken, embodied delivery. I've sat through a lot of obviously (or explicitly
stated) LLM generated slide decks recently and I just cannot imagine
being able to do a good talk myself in this way;[^1] maybe others can do it, but I need that time, that sometimes
painful time, to sit soaking in the material trying to drag out a
coherent story through it. For research talks that almost always then
helps me better understand, analyse, and evaluate the key ideas in the
research itself.

Passing large parts of these tasks (writing, programming, slide
making) to AI then robs us of the chance to think. I don't think this
necessarily means there is no way to use LLMs effectively in the
process of programming, but I think we need to make careful choices
about what we are willing to _not_ think about.

So, writing is thinking, and programming is thinking, and preparing
slide decks is thinking.

Let's keep thinking!

## References

<ol class="references">
  <li id="ref-1">The Economist. <a href="https://www.economist.com/britain/2026/09/24/ai-often-makes-writing-worse-even-if-it-makes-it-better">AI often makes writing worse. (Even if it makes it better)</a>. <em>The Economist</em>, September 2026. <a href="#cite-1" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-2">Simon Peyton Jones. <a href="https://www.robots.ox.ac.uk/~phst/PhD/writing-a-paper-slides.pdf">How to write a great research paper</a>. Slides. <a href="#cite-2" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-3">Keith Oatley and Maja Djikic. <a href="https://doi.org/10.1037/1089-2680.12.1.9">Writing as Thinking</a>. <em>Review of General Psychology</em>, 12(1), 9–27, 2008. <a href="#cite-3" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-4">Richard Menary. <a href="https://doi.org/10.1016/j.langsci.2007.01.005">Writing as thinking</a>. <em>Language Sciences</em>, 29(5), 621–632, 2007. <a href="#cite-4" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-5"><a href="https://www.proquest.com/openview/1e72778b1cd1f2c9ff4a9f4743c1356c/1">ProQuest article</a>. <a href="#cite-5" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-6">Robert Retherford. <a href="https://tesl-ej.org/wordpress/issues/volume2/ej08/ej08r3/">Review of <em>Writing as a Thinking Process</em> by Mary S. Lawrence (University of Michigan Press, 1996)</a>. <em>TESL-EJ</em>, 2(4), 1997. <a href="#cite-6" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-7">Donald Knuth. <a href="https://cacm.acm.org/opinion/interview-donald-knuth-a-lifes-work-interrupted/">Interview: Donald Knuth: A Life's Work Interrupted</a>. <em>Communications of the ACM</em>, 51(8), 31–35, 2008. <a href="#cite-7" class="cite-back" title="Back to text">↩</a></li>
  <li id="ref-8">Jeannette M. Wing. <a href="https://doi.org/10.1145/1118178.1118215">Computational thinking</a>. <em>Communications of the ACM</em>, 49(3), 33–35, 2006. <a href="#cite-8" class="cite-back" title="Back to text">↩</a></li>
</ol>

[^1]: This is similar to how I find it very hard to reuse someone else's slides for teaching; I need the time to think about how I'm going to explain it, otherwise I will not be able to communicate the ideas as effectively. Relatedly, I saw a senior academic give a talk who admitted the slides were AI assisted, and at some point into a slide said "I don't like this slide, AI has made it too complicated" and then they just skipped it!
