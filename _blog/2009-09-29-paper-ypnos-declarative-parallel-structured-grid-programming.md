---
layout: blog-post
title: "Paper: Ypnos, Declarative Parallel Structured Grid Programming"
date: 2009-09-29
categories: [haskell, paper, programming languages]
excerpt: "Max Bolingbroke, Alan Mycroft, and I have written a paper on a new DSL for programming structured grid computations with the view to parallelisation, called Ypnos, submitted to DAMP '10] Abstract: A fully automatic, compiler-driven approach to parallelisation can result in unpredictable time and space costs for compiled code. On..."
wordpress_url: https://dorchard.wordpress.com/2009/09/29/paper-ypnos-declarative-parallel-structured-grid-programming/
---

Max Bolingbroke, Alan Mycroft, and I have written [a paper](http://www.cl.cam.ac.uk/~dao29/publ/ypnos1.html) on a new DSL for programming structured grid computations with the view to parallelisation, called Ypnos, submitted to [DAMP '10](http://damp10.cs.nmsu.edu/)]  
  
Abstract:  
  


> A fully automatic, compiler-driven approach to parallelisation can result in unpredictable time and space costs for compiled code. On the other hand, a fully manual, human-driven approach to parallelisation can be long, tedious, prone to errors, hard to debug, and often architecture-specific. We present a declarative domain-specific language, Ypnos, for expressing structured grid computations which encourages manual specification of causally sequential operations but then allows a simple, predictable, static analysis to generate optimised, parallel implementations. We introduce the language and provide some discussion on the theoretical aspects of the language semantics, particularly the structuring of computations around the category theoretic notion of a _comonad_. 

  
  
Any feedback is welcome. 
