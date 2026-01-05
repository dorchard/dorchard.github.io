---
layout: blog-post
title: "FirstPrelude v0.2.0 for beginner Haskell using GHC"
date: "2026-01-05"
categories: [haskell, teaching, functional-programming]
excerpt: "A simplified Prelude for teaching functional programming without type classes getting in the way."
---

I have taught functional programming to Computer Science undergraduates for nine years now, and have used Haskell for at least six of those, specifically using the [GHC](https://www.haskell.org/ghc/) implementation. One problem I noticed a few years ago is that many simple programming errors made in GHC-Haskell produce type class errors that
are difficult for students to understand. For example, consider the following attempted code:

```haskell
foo :: Integer -> Bool
foo x = mod x == 0
```

When given to GHC, this gives an error like:

```
• No instance for (Num (Integer -> Integer))
        arising from the literal ‘0’
        (maybe you haven't applied a function to enough arguments?)
• In the second argument of ‘(==)’, namely ‘0’
    In the expression: mod x == 0
    In an equation for ‘foo’: foo x = mod x == 0
```
Why? The problem is we forgot to provide the second argument to `mod` in the definition of `foo`. But instead of getting a clear error about a missing argument or type mismatch, we get a cryptic message about a missing `Num` instance for a function type `Integer -> Integer`. 

The problem is not really GHC itself but the use of overloaded numerics in the `Prelude` standard library. If instead
we were using an implementation of Standard ML, these kinds of beginner mistakes would instead result in more cleare error messages. This situation in GHC/Haskell is unfortunate as its pedagogically difficult to teach type classes very early in a course, and so beginners are left without as much support until they learn more topics.

Other difficulties arise from the use of generalisations in `Prelude`, for example the type of `length` is `length :: Foldable t => t a -> Int`. I don't want to have to explain type classes and the idea of `Foldable` before teaching the basics of lists!

Thus, a few years ago I devised a replacement for `Prelude` called [`FirstPrelude`](https://github.com/dorchard/FirstPrelude) that simplifies the standard library to contain no use of type classes, with much more monomorphised functions. Later, the students can be transitioned to traditional `Prelude` after learning about type classes.

The setup is simply to include either:

```
import Prelude()
import FirstPrelude
```

or

```
{-# LANGUAGE NoImplicitPrelude #-}
import FirstPrelude
```

at the start of each file. It would be great if there was a mechanism in GHC to simplify this further, perhaps a special flag for `ghci` to signal 'education mode' or perhaps even an alias `ghcie`. (I am reminded a bit of the progressive language levels idea in [Pyret](https://planet.racket-lang.org/archives/wrturtle/pyret.plt/2/1/contents/planet-docs/manual/)). I could give students a `cabal` setup which removes the need to include these lines, but I wanted to still keep things lightweight and not require too much ecosystem setup at the beginning of the term.

At the start of the new teaching term, I have been doing a few updates to the library and have just made a new release: [v0.2.0.0](https://github.com/dorchard/FirstPrelude). This
closes a few holes that were previously open and could still cause confusion. I've hidden even more type classes that were still poking through, e.g., in functions like `head` which has type `head :: GHC.Stack.Types.HasCallStack => [a] -> a` in `Prelude`.

Of course, another solution to this would have been to use [Helium](https://dl.acm.org/doi/10.1145/871895.871902), an implementation of Haskell which does not have type classes. However, I *do* want to teach type classes eventually (usually in the middle of the course), just not immediately! 

In the future, it would be interesting to design some kind of user study that logs student errors using `FirstPrelude` and then after-the-fact looks at what they would have been using normal `Prelude` from which we could calculate how many type-class-based errors are avoided by the use of `FirstPrelude`. I'm hoping I can design and deploy such a study at some point, but alas no time this year!

## Links

- [FirstPrelude on Hackage](https://hackage.haskell.org/package/FirstPrelude-0.2.0.0)
- [FirstPrelude on GitHub](https://github.com/dorchard/FirstPrelude)
- [Helium on GitHub](https://github.com/Helium4Haskell/helium)