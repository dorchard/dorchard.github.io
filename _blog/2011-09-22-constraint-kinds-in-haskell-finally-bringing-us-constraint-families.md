---
layout: blog-post
title: "Constraint kinds in Haskell, finally bringing us constraint families"
date: "2011-09-22"
categories: [haskell]
excerpt: "Back in 2009 Tom Schrijvers and I wrote a paper entitled Haskell Type Constraints Unleashed [1] which appeared at FLOPS 2010 in April. In the paper we fleshed out the idea of adding constraint synyonyms and constraint families to GHC/Haskell, building upon various existing proposals for class families/indexed constraints. The..."
wordpress_url: https://dorchard.wordpress.com/2011/09/22/constraint-kinds-in-haskell-finally-bringing-us-constraint-families/
---

Back in 2009 [Tom Schrijvers](http://users.ugent.be/~tschrijv/) and I wrote a paper entitled _Haskell Type Constraints Unleashed_ [1] which appeared at [FLOPS 2010](http://www.kb.ecei.tohoku.ac.jp/flops2010/wiki/) in April. In the paper we fleshed out the idea of adding _constraint synyonyms_ and _constraint families_ to GHC/Haskell, building upon various existing proposals for _class families_ /_indexed constraints_. The general idea in our paper, and in the earlier proposals, is to add a mechanism to GHC/Haskell to allow constraints, such as type class or equality constraints, to be indexed by a type in the same way that type families and data families allow types to be indexed by types. As an example of why constraint families are useful, consider the following type class which describes a simple, polymorphic, embedded language in Haskell (in the "_finally tagless_ "-style [2]) (this example appears in [1]): 
    
    
    class Expr sem where
        constant :: a -> sem a
        add :: sem a -> sem a -> sem a
    

Instances of `Expr` provide different evaluation semantics for the language. For example, we might like to evaluate the language for numerical values, so we might try and write the following instance: 
    
    
    data E a = E {eval :: a}
    
    instance Expr E where
         constant c = E c
         add e1 e2 = E $ (eval e1) + (eval e2)
    

However, this instance does not type check. GHC returns the type error: 
    
    
        No instance for (Num a)
          arising from a use of `+'
        In the second argument of `($)', namely `(eval e1) + (eval e2)'
        ...
    

The `+` operation requires the `Num a` constraint, yet the signature for `add` states no constraints on type variable `a`, thus the constraint is never satisfied in this instance. We could add the `Num a` constraint to the signature of `add`, but this would restrict the polymorphism of the language: further instances would have this constraint forced upon them. Other useful semantics for the language may require other constraints e.g. `Show a` for pretty printing. Should we just add more and more constraints to the class? By no means! _Constraint families_ , as we describe in [1], provide a solution: by associating a constraint family to the class we can vary, or _index_ , the constraints in the types of `add` and `constant` by the type of an instance of `Expr`. The solution we suggest looks something likes: 
    
    
    class Expr sem where
        constraint Pre sem a
        constant :: Pre sem a => a -> sem a
        add :: Pre sem a => sem a -> sem a -> sem a
    
    instance Expr E where
        constraint Pre E a = Num a
        ... -- methods as before
    

`Pre` is the name of a constraint family that takes two type parameters and returns a constraint, where the first type parameter is the type parameter of the `Expr` class. We could add some further instances: 
    
    
    data P a = P {prettyP :: String}
    
    instance Expr P where
        constraint Pre P a = Show a
        constant c = P (show c)
        add e1 e2 = P $ prettyP e1 ++ " + " ++ prettyP e2
    

e.g. 
    
    
    *Main> prettyP (add (constant 1) (constant 2))
    "1 + 2"
    

At the time of writing the paper I had only a prototype implementation in the form of a preprocessor that desugared constraint families into some equivalent constructions (which were significantly more awkward and ugly of course). There has not been a proper implementation in GHC, or of anything similar. Until now. At CamHac, the Cambridge Haskell Hackathon, last month, [Max Bolingbroke](http://www.cl.cam.ac.uk/~mb566/) started work on an extension for GHC called "constraint kinds". The new extensions unifies types and constraints such that the only distinction is that constraints have a special _kind_ , denoted `Constraint`. Thus, for example, the |Show| class constructor is actually a type constructor, of kind: 
    
    
    Show :: * -> Constraint
    

For type signatures of the form `C => t`, the left-hand side is now a type term of kind `Constraint`. As another example, the equality constraints constructor `~` now has kind: 
    
    
    ~ :: * -> * -> Constraint
    

i.e. it takes two types and returns a constraint. Since constraints are now just types, existing type system features on type terms, such as synonyms and families, can be reused on constraints. Thus we can now define _constraint synonyms_ via standard type synonms e.g. 
    
    
    type ShowNum a = (Num a, Show a)
    

And most excitingly, _constraint families_ can be defined via type families of return kind `Constraint`. Our previous example can be written: 
    
    
    class Expr sem where
        type Pre sem a :: Constraint
        constant :: Pre sem a => a -> sem a
        add :: Pre sem a => sem a -> sem a -> sem a
    
    instance Expr E where
        type Pre E a = Num a
        ...
    

Thus, `Pre` is a type family of kind `* -> * -> Constraint`. And it all works! The constraint kinds extension can be turned on via the pragma: 
    
    
    {-# LANGUAGE ConstraintKinds #-}
    

Max has written about the extension over at [his blog](http://blog.omega-prime.co.uk/?p=127), which has some more examples, so do go check that out. As far as I am aware the extension should be hitting the streets with version 7.4 of GHC. But if you can't wait it is already in the GHC HEAD revision so you can checkout a [development snapshot](http://www.haskell.org/ghc/download) and give it a whirl. In my next post I will be showing how we can use the constraint kinds extension to describe abstract structures from category theory in Haskell that are defined upon _subcategories_. I already have a draft note about this (edit July 2012: draft note subsumed by my [TFP 2012 submission](http://www.cl.cam.ac.uk/~dao29/drafts/tfp-structures-orchard12.pdf "TFP 2012 submission")) submission if you can't wait! ****

### References

****[[1] Orchard, D. Schrijvers, T.:_Haskell Type Constraints Unleashed_ , FLOPS 2010](http://www.cl.cam.ac.uk/~dao29/publ/constraint-families.pdf), [[author's copy with corrections](http://www.cl.cam.ac.uk/~dao29/publ/constraint-families.pdf)] [[On SpringerLink](http://www.springerlink.com/content/r87810un65965001/)]  [2] Carrete, J., Kiselyov, O., Shan, C. C.: _Finally Tagless, Partially Evaluated_ , APLAS 2007 
