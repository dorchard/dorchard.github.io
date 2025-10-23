---
layout: blog-post
title: "Subcategories & 'Exofunctors' in Haskell"
date: "2011-10-18"
categories: [haskell, maths]
excerpt: "In my previous post I discussed the new constraint kinds extension to GHC, which provides a way to get type-indexed constraint families in GHC/Haskell. The extension provides some very useful expressivity. In this post I'm going to explain a possible use of the extension. In Haskell the Functor class is..."
wordpress_url: https://dorchard.wordpress.com/2011/10/18/subcategories-in-haskell-exofunctors/
---

In my [previous post](http://dorchard.wordpress.com/2011/09/22/constraint-kinds-in-haskell-finally-bringing-us-constraint-families/) I discussed the new _constraint kinds_ extension to GHC, which provides a way to get type-indexed constraint families in GHC/Haskell. The extension provides some very useful expressivity. In this post I'm going to explain a possible use of the extension.

In Haskell the `Functor` class is misleading named as it actually captures the notion of an _endo_ functor, not functors in general. This post shows a use of constraint kinds to define a type class of _exo_ functors; that is, functors that are not necessarily endofunctors. I will explain what all of this means. 

This example is just one from a draft note (edit July 2012: draft note subsumed by my [](http://www.cl.cam.ac.uk/~dao29/drafts/tfp-structures-orchard12.pdf "TFP 2012 submission")TFP 2012 submission) explaining the use of constraint families, via the constraint kinds extension, for describing abstract structures from category theory that are parameterised by _subcategories_ , including non-endofunctors, _relative monads_ , and _relative comonads_.

I will try to concisely describe any relevant concepts from category theory, through the lens of functional programming, although I'll elide some details.

### The **Hask** category

The starting point of the idea is that programs in Haskell can be understood as providing definitions within some category, which we will call **Hask**. Categories comprise a collection of _objects_ and a collection of _morphisms_ which are mappings between objects. Categories come equipped with identity morphisms for every object and an associative composition operation for morphisms (see [Wikipedia](http://en.wikipedia.org/wiki/Category_theory#Categories.2C_objects.2C_and_morphisms) for a more complete, formal definition). For **Hask** , the objects are Haskell types, morphisms are functions in Haskell, identity morphisms are provided by the identity function, and composition is the usual function composition operation. For the purpose of this discussion we are not really concerned about the exact properties of **Hask** , just that Haskell acts as a kind of _internal language_ for category theory, within some arbitrary category **Hask** ([Dan Piponi provides some discussion on this topic](http://blog.sigfpe.com/2009/10/what-category-do-haskell-types-and.html)). 

### Subcategories

Given some category _C_ , a [_subcategory_](http://en.wikipedia.org/wiki/Subcategory) of _C_ comprises a subcollection of the objects of _C_ and a subcollection of the morphisms of _C_ which map only between objects in the subcollection of this subcategory.

We can define for **Hask** a _singleton_ subcategory for each type, which has just that one type as an object and functions from that type to itself as morphisms e.g. the _Int_ -subcategory of **Hask** has one object, the `Int` type, and has functions of type `Int → Int` as morphisms. If this subcategory has _all_ the morphisms `Int → Int` it is called a _full_ subcategory. Is there a way to describe "larger" subcategories with more than just one object?

Via universal quantification we could define the trivial (["non-proper"](http://en.wikipedia.org/wiki/Proper_subset#proper_subset)) subcategory of **Hask** with objects of type `a` (implicitly universally quantified) and morphisms `a -> b`, which is just **Hask** again. Is there a way to describe "smaller" subcategories with fewer than all the objects, but more than one object? Yes. For this we use type classes.

### Subcategories as type classes

The instances of a single parameter type class can be interpreted as describing the members of a set of types (or a relation on types for multi-parameter type classes). In a type signature, a universally quantified type variable constrained by a type class constraint represents a collection of types that are members of the class. E.g. for the `Eq` class, the following type signature describes a collection of types for which there are instances of `Eq`: 

`Eq a => a`

The members of `Eq` are a subcollection of the objects of **Hask**. Similarly, the type: 

`(Eq a, Eq b) => (a -> b)`

represents a subcollection of the morphisms of **Hask** mapping between objects in the subcollection of objects which are members of `Eq`. Thus, the `Eq` class defines an _Eq_ -subcategory of **Hask** with the above subcollections of objects and morphisms.

Type classes can thus be interpreted as describing subcategories in Haskell. In a type signature, a type class constraint on a type variable thus specifies the subcategory which the type variable ranges over the objects of. We will go on to use the constraint kinds extension to define constraint-kinded type families, allowing structures from category theory to be parameterised by subcategories, encoded as type class constraints. We will use _functors_ as the example in this post (more examples [here](http://www.cl.cam.ac.uk/~dao29/drafts/subcategories-in-haskell-dorchard11.pdf)). 

### Functors in Haskell

In category theory, a functor provides a mapping between categories e.g. _F : C → D_ , mapping the objects and morphisms of _C_ to objects and morphisms of _D_. Functors preserves identities and composition between the source and target category (see [Wikipedia](http://en.wikipedia.org/wiki/Functor) for more). An _endofunctor_ is a functor where _C_ and _D_ are the same category. 

The type constructor of a parametric data type in Haskell provides an object mapping from **Hask** to **Hask** e.g. given a data type `data F a = ...` the type constructor `F` maps objects (types) of **Hask** to other objects in **Hask**. A functor in Haskell is defined by a parametric data type, providing an object mapping, and an instance of the well-known `Functor` class for that data type: `
    
    
    class Functor f where
       fmap :: (a -> b) -> f a -> f b
    

` which provides a mapping on morphisms, called `fmap`. There are many examples of functors in Haskell, for examples lists, where the `fmap` operation is the usual map operation, or the `Maybe` type. However, not all parametric data types are functors. 

It is well-known that the `Set` data type in Haskell cannot be made an instance of the `Functor` class. The `Data.Set` library provides a map operation of type: `
    
    
     
    Set.map :: (Ord a, Ord b) => (a -> b) -> Set a -> Set b
    

` The `Ord` constraint on the element types is due to the implementation of `Set` using balanced binary trees, thus elements must be comparable. Whilst the data type is declared polymorphic, the constructors and transformers of `Set` allow only elements of a type that is an instance of `Ord`. 

Using `Set.map` to define an instance of the `Functor` class for `Set` causes a type error: `
    
    
    instance Functor Set where
       fmap = Data.Set.map
    
    ...
    
    foo.lhs:4:14:
        No instances for (Ord b, Ord a)
          arising from a use of `Data.Set.map'
        In the expression: Data.Set.map
        In an equation for `fmap': fmap = Data.Set.map
        In the instance declaration for `Functor Set'
    

` The type error occurs as the signature for `fmap` has no constraints, or the _empty_ (always true) constraint, whereas `Set.map` has `Ord` constraints. A mismatch occurs and a type error is produced. 

The type error is however well justified from a mathematical perspective. 

### Haskell functors are not functors, but endofunctors

First of all, the name `Functor` is a misnomer; the class actually describes _endo_ functors, that is functors which have the same category for their source and target. If we understand type class constraints as specifying a subcategory, then the lack of constraints on `fmap` means that `Functor` describes endofunctors **Hask** → **Hask**. 

The `Set` data type is not an endofunctor; it is a functor which maps from the _Ord_ -subcategory of **Hask** to **Hask**. Thus `Set ::` _Ord_` → `**Hask**. The class constraints on the element types in `Set.map` declare the subcategory of `Set` functor to which the morphisms belong. 

### Type class of _exo_ functors

Can we define a type class which captures functors that are not necessarily endofunctors, but may have distinct source and target categories? Yes, using an associated type family of kind `Constraint`. 

The following `ExoFunctor` type class describes a functor from a subcategory of **Hask** to **Hask** : `
    
    
    {-# LANGUAGE ConstraintKinds #-}
    {-# LANGUAGE TypeFamilies #-}
    
    class ExoFunctor f where
       type SubCat f x :: Constraint
       fmap :: (SubCat f a, SubCat f b) => (a -> b) -> f a -> f b
    

` The `SubCat` family defines the source subcategory for the functor, which depends on `f`. The target subcategory is just **Hask** , since `f a` and `f b` do not have any constraints. 

We can now define the following instance for `Set`: `
    
    
    instance ExoFunctor Set where
       type SubCat Set x = Ord x
       fmap = Set.map
    

` Endofunctors can also be made an instance of `ExoFunctor` using the empty constraint e.g.: `
    
    
    instance ExoFunctor [] where
        type SubCat [] a = ()
        fmap = map
    

`

(Aside: one might be wondering whether we should also have a way to restrict the target subcategory to something other than **Hask** here. By covariance we can always "cast" a functor _C → D_ , where _D_ is a subcategory of some other category _E_ , to _C → E_ without any problems. Thus, there is nothing to be gained from restricting the target to a subcategory, as it can always be reinterpreted as **Hask**.) 

### Conclusion (implementational restrictions = subcategories)

Subcategory constraints are needed when a data type is restricted in its polymorphism by its operations, usually because of some hidden implementational details that have permeated to the surface. These implementational details have until now been painful for Haskell programmers, and have threatened abstractions such as functors, monads, and comonads. Categorically, these implementational restrictions can be formulated succinctly with subcategories, for which there are corresponding structures of non-endofunctors, relative monads, and relative comonads. Until now there has been no succinct way to describe such structures in Haskell. 

Using constraint kinds we can define associated type families, of kind `Constraint`, which allow abstract categorical structures, described via their operations as a type class, to be parameterised by subcategories on a per-instance basis. We can thus define a class of _exo_ functors, i.e. functors that are not necessarily endofunctors, which we showed here. The other related structures which are difficult to describe in Haskell without constraint kinds: _relative monads_ and _relative comonads_ , are discussed further in a draft note (edit July 2012: draft note subsumed by my [](http://www.cl.cam.ac.uk/~dao29/drafts/tfp-structures-orchard12.pdf "TFP 2012 submission")TFP 2012 submission). The note includes examples of a _Set_ monad and an unboxed array comonad, both of which expose their implementational restrictions as type class constraints which can be described as subcategory constraints. Any feedback on this post or the draft note is greatly appreciated. Thanks. 
