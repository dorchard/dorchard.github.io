---
layout: blog-post
title: "Automatic SIMD Vectorization for Haskell and ICFP 2013"
date: "2013-10-14"
categories: [paper, programming languages]
excerpt: "I had a great time at ICFP 2013 this year where I presented my paper 'Automatic SIMD Vectorization for Haskell', which was joint work with Leaf Petersen and Neal Glew of Intel Labs. The full paper and slides are available online. Our paper details the vectorization process in the Intel..."
wordpress_url: https://dorchard.wordpress.com/2013/10/14/automatic-simd-vectorization-for-haskell-and-icfp-2013/
---

I had a great time at [ICFP 2013](http://icfpconference.org/icfp2013/) this year where I presented my paper "Automatic SIMD Vectorization for Haskell", which was joint work with Leaf Petersen and Neal Glew of Intel Labs. The **[full paper](http://www.cl.cam.ac.uk/~dao29/publ/icfp-2013-simd-vectorisation.pdf "full paper")** and **[slides](http://www.cl.cam.ac.uk/~dao29/talks/slides-automatic-simd-haskell-icfp2013.pdf "slides")** are available online. Our paper details the vectorization process in the Intel Labs Haskell Research Compiler (HRC) which gets decent speedups on numerical code (between 2-7x on 256-bit vector registers). It was nice to be able to talk about HRC and share the results. Paul (Hai) Liu also gave a talk at the Haskell Symposium which has more details about HRC than the vectorization paper ([see the paper here](http://www.leafpetersen.com/leaf/publications/hs2013/hrc-paper.pdf) with Neal Glew, Leaf Petersen, and Todd Anderson). Hopefully there will be a public release of HRC in future. 

**Still more to do**

It's been exciting to see the performance gains in compiled functional code over the last few years, and its encouraging to see that there is still much more we can do and explore. HRC outperforms GHC on roughly 50% of the benchmarks, showing some interesting trade-offs going on in the two compilers. HRC is particularly good at compiling high-throughput numerical code, thanks to various strictness/unboxing optimisations (and the vectorizer), but there is still more to be done.

**Don't throw away information about your programs**

One thing I emphasized in my talk was the importance of keeping, not throwing away, the information encoded in our programs as we progress through the compiler stack. In the HRC vectorizer project, Haskell's Data.Vector library was modified to distinguish between mutable array operations and "initializing writes", a property which then gets encoded directly in HRC's intermediate representation. This makes vectorization discovery much easier. We aim to preserve as much effect information around as possible in the IR from the original Haskell source.

This connected nicely with something Ben Lippmeier emphasised in his Haskell Symposium paper this year ("[Data Flow Fusion with Series Expressions in Haskell](http://www.cse.unsw.edu.au/~benl/papers/flow/flow-Haskell2013.pdf)", joint with Manuel Chakravarty, Gabriele Keller and Amos Robinson). They provide a combinator library for first-order non-recursive dataflow computations which is  _guaranteed_ to be optimised using  _flow fusion_(outperforming current stream fusion techniques). The important point Ben made is that, if your program fits the pattern, this optimisation is guaranteed. As well as being good for the compiler, this provides an obvious cost model for the user (no more games trying to coax the compiler into optimising in a particular way).

This is something that I have explored in the [Ypnos array language](http://www.cl.cam.ac.uk/~dao29/publ/ypnos-damp10.pdf), where the syntax is restricted to give (fairly strong) language invariants that guarantee parallelism and various optimisations, without undecidable analyses. The idea is to make static as much effect and coeffect (context dependence) information as possible. In Ypnos, this was so successful that I was able to encode the Ypnos' language invariant of no out-of-bounds array access directly in Haskell's type system [(shown in the DSL'11 paper](http://arxiv.org/abs/1109.0777); this concept was also discussed briefly in my [short language design essay](http://www.cl.cam.ac.uk/~dao29/publ/onwards-essay-orchard11.pdf)).

This is a big selling point for DSLs in general: restrict a language such that various program properties are statically decidable, facilitating verification and optimisation.

Ypnos has actually had some more development in the past year, so if things progress further, there may be some new results to report on. I hope to be posting again soon about more research, including the ongoing work with Tomas Petricek on coeffect systems, and various other things I have been playing with. - D
