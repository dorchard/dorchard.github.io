---
layout: blog-post
title: "Paper: Haskell Type Constraints Unleashed"
date: "2009-11-04"
categories: [paper]
excerpt: "Tom Schrijvers and I have a new paper describing extensions to Haskell's type-constraint term language, which considerably increases its flexibility. These extensions are particularly useful when writing polymorphic EDSLs in Haskell, thus expanding Haskell's capacity for embedding DSLs. Abstract: The popular Glasgow Haskell Compiler extends the Haskell 98 type system..."
wordpress_url: https://dorchard.wordpress.com/2009/11/04/paper-haskell-type-constraints-unleashed/
---

Tom Schrijvers and I have [a new paper](http://www.cl.cam.ac.uk/~dao29/publ/constraint-families.pdf) describing extensions to Haskell's type-constraint term language, which considerably increases its flexibility. These extensions are particularly useful when writing polymorphic EDSLs in Haskell, thus expanding Haskell's capacity for embedding DSLs. Abstract: 

> The popular Glasgow Haskell Compiler extends the Haskell 98 type system with several powerful features, leading to an expressive language of type terms. In contrast, constraints over types have received much less attention, creating an imbalance in the expressivity of the type system. In this paper, we rectify the imbalance, transferring familiar type-level constructs, _synonyms_ and _families_ , to the language of constraints, providing a symmetrical set of features at the type-level and constraint-level. We introduce _constraint synonyms_ and _constraint families_ , and illustrate their increased expressivity for improving the utility of polymorphic EDSLs in Haskell, amongst other examples. We provide a discussion of the semantics of the new features relative to existing type system features and similar proposals, including details of termination. 

[[draft pdf](http://www.cl.cam.ac.uk/~dao29/publ/constraint-families.pdf) submitted to [FLOPS 2010](http://http//www.kb.ecei.tohoku.ac.jp/flops2010/wiki/)] Any feedback is most welcome. Blog posts to follow if you are too lazy to read the paper. 
