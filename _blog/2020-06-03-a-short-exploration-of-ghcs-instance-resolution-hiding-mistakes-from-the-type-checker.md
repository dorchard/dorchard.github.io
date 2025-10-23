---
layout: blog-post
title: "A short exploration of GHC's instance resolution hiding mistakes from the type checker."
date: 2020-06-03
categories: [haskell]
excerpt: "I was recently working on some Haskell code (for research, with Jack Hughes) and happened to be using a monoid (via the Monoid type class) and I was rushing. I accidentally wrote x `mempty` y instead of x `mappend` y. The code with mempty type checked and compiled, but I..."
wordpress_url: https://dorchard.wordpress.com/2020/06/03/a-short-exploration-of-ghcs-instance-resolution-hiding-mistakes-from-the-type-checker/
---

I was recently working on some Haskell code (for research, with [Jack Hughes](https://twitter.com/jackolhughes)) and happened to be using a monoid (via the `Monoid` type class) and I was rushing. I accidentally wrote `x `mempty` y` instead of `x `mappend` y`. The code with `mempty` type checked and compiled, but I quickly noticed some tests giving unexpected results. After a pause, I checked the recent diff and noticed this mistake, but I had to think for a moment about why this mistake was not leading to a type error. I thought this was an interesting little example of how type class instance resolution can sometimes trip you up in Haskell, and how to uncover what is going on. This also points to a need for GHC to explain its instance resolution, something others have thought about; I will briefly mention some links at the end. 

## The nub of the problem

In isolation, my mistake was essentially this: 
    
    
    whoops :: Monoid d => d -> d -> d
    whoops x y = mempty x y  -- Bug here. Should be "mappend x y"
    

So, given two parameters of type `d` for which there is a monoid structure on `d`, we use both parameters as arguments to `mempty`. Recall the `Monoid` type class is essentially: 
    
    
    class Monoid d where
      mempty :: d
      mappend :: d -> d -> d
    

(note that ​​`Monoid` also has a derived operation `mconcat` and is now decomposed into `Semigroup` and `Monoid` but I elide that detail here, see <https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#t:Monoid>). We might naively think that `whoops` would therefore not type check since we do not know that `d` is a function type. However, `whoops` **is** well-typed and evaluating `whoops [1,2,3] [4,5,6]` returns `[]`. If the code had been as I intended, (using `mappend` here instead of `mempty`) then we would expect `[1,2,3,4,5,6]` according to the usual monoid on lists. The reason this is not a type error is because of GHC's instance resolution and the following provided instance of `Monoid`: 
    
    
    instance Monoid b => Monoid (a -> b) where
      mempty = \_ -> mempty
      mappend f g = \x -> f x `mappend` g x

That is, functions are monoids if their domain is a monoid with `mempty` as the constant function returning the `mempty` element of `b` and `mappend` as the pointwise lifting of a monoid to a function space. In this case, we can dig into what is happening by compiling1 with `--ddump-ds-preopt` and looking at GHC's desugared output before optimisation, where all the type class instances have been resolved. I've cleaned up the output a little (mostly renaming): 
    
    
    whoops :: forall d. Monoid d => d -> d -> d
    whoops = \ (@ d) ($dMonoid :: Monoid d) ->
      let
        $dMonoid_f :: Monoid (d -> d)
        $dMonoid_f = GHC.Base.$fMonoid-> @ d @ d $dMonoid }
    
        $dMonoid_ff :: Monoid (d -> d -> d)
        $dMonoid_ff = GHC.Base.$fMonoid-> @ (d -> d) @ d $dMonoid_f }
      in
        \ (x :: d) (y :: d) -> mempty @ (d -> d -> d) $dMonoid_ff x y

The second line shows `whoops` has a type parameter (written `@ d`) and the incoming dictionary `$dMonoid` representing the `Monoid d` type class instance (type classes are implemented as data types called dictionaries, and I use the names `$dMonoidX` for these here). Via the explicit type application (of the form `@ t` for a type term `t`) we can see in the last line that `mempty` is being resolved at the type `d -> d -> d` with the monoid instance `Monoid (d -> d -> d)` given here by the `$dMonoid_ff` construction just above. This is in turn derived from the `Monoid (d -> d)` given by the dictionary construction `$dMonoid_f` just above that. Thus we have gone twice through the lifting of a monoid to a function space, and so our use of `mempty` here is: 
    
    
    mempty @ (d -> d -> d) $dMonoid_ff = \_ -> (\_ -> mempty @ $dMonoid)

thus 
    
    
    mempty @ (d -> d -> d) $dMonoid_ff x y = mempty @ d $dMonoid

That's why the program type checks and we see the `mempty` element of the original intended monoid on `d` when applying `whoops` to some arguments and evaluating. 

## Epilogue

I luckily spotted my mistake quite quickly, but this kind of bug can be a confounding experience for beginners. There has been some discussion about extending GHCi with a feature allowing users to ask GHC to explain its instance resolution. Michael Sloan has a nice [write up discussing the idea](https://mgsloan.com/posts/inspecting-haskell-instance-resolution/) and there is a [GHC ticket proposing](https://gitlab.haskell.org/ghc/ghc/issues/15613) by [Icelandjack](https://gitlab.haskell.org/Icelandjack) something similar which seems like it would work well in this context where you want to ask what the instance resolution was for a particular expression. There are many much more confusing situations possible that get hidden by the implicit nature of instance resolution, so I think this would be a very useful feature, for beginner and expert Haskell programmers alike. And it certainly would have explained this particular error quickly to me without me having to scribble on paper and then check `--ddump-ds-preopt` to confirm my suspicion. **Additional** : I should also point out that this kind of situation could be avoided if there were ways to scope, import, and even name type class instances. The monoid instance `Monoid b => Monoid (a -> b)` is very useful, but having it in scope _by default_ as part of `base` was really the main issue here. 

* * *

1 To compile, put this in a file with a `main` stub, e.g. 
    
    
    main :: IO ()
    main = return ()
