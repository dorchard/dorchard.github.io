A colleague recently pointed me at this lovely article in the
Economist, titled "AI often makes writing worse. (Even if it makes it
better)". The article includes the following argument:

"Real writing is not writing at all. It is thinking; specifically it
is thinking: “What do I think?"" [1] https://www.economist.com/britain/2026/09/24/ai-often-makes-writing-worse-even-if-it-makes-it-better


It goes on to quote Prof. Emma Smith (University of Oxford:
"Often “you only really know what you think by writing it,”".

This reminded me of two other quotes which I have pinned in my
'team' repository that I share with all my students and postdocs:

"If you're thinking without writing, you only think you're
thinking. [...] Everyone thinks they think. If you don't write down
your thoughts, you are fooling yourself." — Leslie Lamport, creator of
LaTeX (a document prepration system)

"Writing is Nature's way of showing you how sloppy your thinking is."
- Dick Guindon, cartoonist

This aligns with the advice Simon Peyton Jones gives, that
as soon as you have an idea, to start writing the paper about it
(https://www.robots.ox.ac.uk/~phst/PhD/writing-a-paper-slides.pdf).
Why? Because it forces you to confront what you don't yet understand and
what evidence is needed, and it opens up a way to have a dialogue
with others who can critique and collaborate on the idea.

In all of these quotes, people are tapping into the idea that many
people have discovered, that the act of writing gives you a chance to
start really think about a problem, and that doing so generates new
ideas, deepens your exploration of the problem or ideas, and helps to
understand how to evaluate it.

Going back to the Economist article, the point is that if we give
writing over to AI we lose that opportunity to think for ourselves. I
know some find it daunting, but I actually relish starting with an
empty page and a fresh idea because I know that's where the action
happens: getting it down helps my brain to think it through rather
than "fooling myself" (Lamport) that I understand the idea well
enough. And if I get stuck I can always switch it up and try
some different writing strategies (I have written a whole list of
them to help me and my students overcome writer's block: https://dorchard.github.io/advice/writing-strategies.html).

If writing is thinking, then I think the same can be said for programming. We are in a world
where AI agents are writing large amounts of code, and people are wondering
whether software engineering is a dying art with code increasingly
becoming  just an opaque box we do not need to, or indeed cannot reasonably, inspect.
But just as 'writing is thinking' [2,3,4,5] (yes lots of peolpe have investigate
this over the ages), programming is thinking too! At least,
it can be. Many times I've grappled with an interesting problem
or idea by writing code about it.  I often tell undergraduate students to
'implement mathematics' as a way of helping them to get a better
intuitive grasp of the ideas. By programming the theory, the student gains a deeper appreciation for
these typically more abstract concepts. A germane quote:

"People have said you don’t
understand something until you’ve taught it in a class. The truth is
you don’t really understand something until you’ve taught it to a
computer, until you’ve been able to program it." (George Forsythe)

(I couldn't find the origin for the quote but it is mentioned
in this Communications of the ACM interview with Donald Knuth which touches on similar ideas:)
[6]

The point is that computers are very stupid. To 'explain' an idea
you have to spell out a lot of the details in excruitating detail.
But doing so makes sure that you yourself understand them. And then
you have an object which you can inspect and probe, with by running
it with particular inputs or other kinds of analysis. If we just automatically
turn to an LLM to do our programming work we miss out on the opportunity
to actually explore a problem or an idea. Not all programming is like
this, but certainly some is. This can be seen as part
of the broader idea also of 'computational thinking' [7], leveraging
ideas from computation as analytical techniues to
help solve problems an ddesign systems.

I think that a similar argument could be made for other kinds of
'content production'. Perhaps a bit more of parochial example
but for similar reasoning, I propose that writing slides is thinking.

I honestly find writing slides for talks and lectures to be a hard
slog, and it is a significant component of my job. But the process of
writing those slides (which can take me as long as a day for a one hour
talk or lecture) gives me a chance to think through what the key messages
I want to get across are, how I want to say it, in what order, and
what story I want to tell or examples I want to include. The deep work
of staring at blank slides, moving bits of text and pictures around,
is a time when my brain is preparing all the ground work for the
actual spoken, embodied delivery. I've sat through a lot of obviously (or explicitly
stated) LLM generated slide decks recently and I just cannot imagine
being able to do a good talk myself in this way;\footnote{This is
similar to how I find it very hard to reuse someone elses slides for
teaching; I need the time to think about how I'm going to explain it,
otherwise I will not be able to communicate the ideas as
effectively. Related I saw a senior academic give a talk who admitted
the slides were AI assisted, and at some point into a slide said "I
don't like this slide, AI has made it too complicated" and then they
just skipped!}  maybe others can do it, but I need that time, that
painful time, to sit soaking in the material trying to drag our a
coherent story through it. For research talks that almost always then
helps me better understand, analyse, and evaluate the key ideas in the
research itself.

Passing large parts of these tasks (writing, programming, slide
making) to AI then robs us of the chance to think. I don't think this
necessarily means there is no way to use LLMs effectively in the
process of programming, but I think we need to be make careful choices
about what we are willing to _not_ think about.

So, writing is thinking, and programming is thinking, and preparing
slide decks is thinking.

Let's keep thinking!


[1] https://www.economist.com/britain/2026/09/24/ai-often-makes-writing-worse-even-if-it-makes-it-better

[2] https://journals.sagepub.com/doi/full/10.1037/1089-2680.12.1.9?casa_token=hloAuvJIuXIAAAAA%3A6nCaDhNRBBcat_beoKpK2TQCFGZl8IHq2frQb4Ge6cn-GBxYLHWsI2bSYriErFIlK_OK84OjQ9oV

[3] https://www.sciencedirect.com/science/article/pii/S0388000107000046?casa_token=TFFqdEFF1CUAAAAA:0rhU3-Dn0NsbyOqs6jr0c90KuClVgmFn_QZHqhSBP8HjPS5HPjBycR9iU-1UnpGLHda8rGAwSw

[4] https://www.proquest.com/openview/1e72778b1cd1f2c9ff4a9f4743c1356c/1?pq-origsite=gscholar&cbl=1817213

[5] https://tesl-ej.org/wordpress/issues/volume2/ej08/ej08r3/

[6] https://cacm.acm.org/opinion/interview-donald-knuth-a-lifes-work-interrupted/

[7] https://dl.acm.org/doi/10.1145/1118178.1118215