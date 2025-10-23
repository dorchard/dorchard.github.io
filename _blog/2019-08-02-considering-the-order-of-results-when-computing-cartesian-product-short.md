---
layout: blog-post
title: "Considering the order of results when computing Cartesian product [short]"
date: "2019-08-02"
categories: [haskell, maths]
excerpt: "Sometimes in programming you need to do a pairwise comparison of some elements coming from two collections, for example, checking possible collisions between particles (which may be embedded inside a quadtree representation for efficiency). A handy operation is then the Cartesian product of the two sets of elements, to get..."
wordpress_url: https://dorchard.wordpress.com/2019/08/02/considering-the-order-of-results-when-computing-cartesian-product-short/
---

Sometimes in programming you need to do a pairwise comparison of some elements coming from two collections, for example, checking possible collisions between particles (which may be embedded inside a [quadtree](https://en.wikipedia.org/wiki/Quadtree) representation for efficiency). A handy operation is then the [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product) of the two sets of elements, to get the set of all pairs, which can then be traversed. Whenever I need a Cartesian product of two lists in Haskell, I whip out the [list monad](https://en.wikibooks.org/wiki/Haskell/Understanding_monads/List) to generate the Cartesian product: 
    
    
    cartesianProduct :: [a] -> [b] -> [(a, b)]
    cartesianProduct as bs = as >>= (\a -> bs >>= (\b -> [(a, b)]))

Thus for every element `a` in `as` we get every element `b` in `bs` and form the singleton list of the pair `(a, b)`, all of which get concatenated to produce the result. For example: 
    
    
    *Main> cartesianProduct [1..4] [1..4]
    [(1,1),(1,2),(1,3),(1,4),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(4,1),(4,2),(4,3),(4,4)]

This traverses the Cartesian space in row order. That is, if we imagine the square grid of possibilities here (where the element at the ith row and jth column corresponds to element `(i, j)`), then `cartesianProduct` generates the pairs in the following order: ![cp-rowOrder](https://dorchard.wordpress.com/wp-content/uploads/2019/08/cp-roworder.png) In mathematics, the Cartesian product is defined on sets, so the order of these pairs is irrelevant. Indeed, if we want to examine all pairs, then it may not matter in what order. However, if we learn something as we look at the pairs (i.e., accumulating some state), then the order can be important. In some recent research, I was building an automated algebra tool to find axioms for some algebraic structure, based on an interpretation. This involved generating all pairs of syntax trees `t` and `t'` of terms over the algebraic structure, up to a particular depth, and evaluating whether `t = t'`. I also had some automated proof search machinery to make sure that this equality wasn't already derivable from the previously generated axioms. I could have done this derivability check as a filtering afterwards, but I was exploring a very large space, and did not expect to even be able to generate all the possibilities. I just wanted to let the thing run for a few hours and see how far it got. Therefore, I needed Cartesian product to get all pairs, but the order in which I generated the pairs became important for the effectiveness of my approach. The above ordering ([row major order](https://en.wikipedia.org/wiki/Row-_and_column-major_order)) was not so useful as I was unlikely to find interesting axioms quickly by traversing the span of a (very long) row; I needed to unpack the space in a more balanced way. My first attempt at a more balanced Cartesian product was the following: 
    
    
    cartesianProductBalanced :: [a] -> [b] -> ([(a, b)])
    cartesianProductBalanced as bs =
         concatMap (zip as) (tails bs)
      ++ concatMap (flip zip bs) (tail (tails as))

`tails` gives the list of successively applying `tail`, e.g., `tails [1..4]` = `[[1,2,3,4],[2,3,4],[3,4],[4],[]]` This definition for `cartesianProductBalanced` essentially traverses the diagonal of the space and then the [lower triangle ](https://en.wikipedia.org/wiki/Triangular_matrix)of the matrix, progressing away from the diagonal to the bottom-left, then traversing the upper triangle of the matrix (the last line of code), progressing away from the diagonal to the top-right corner. The ordering for a 4x4 space is then:
    
    
    *Main> cartesianProductBalanced [1..4] [1..4]
    [(1,1),(2,2),(3,3),(4,4),(1,2),(2,3),(3,4),(1,3),(2,4),(1,4),(2,1),(3,2),(4,3),(3,1),(4,2),(4,1)]

![cp-low-then-upper](https://dorchard.wordpress.com/wp-content/uploads/2019/08/cp-low-then-upper.png) This was more balanced, giving me a better view of the space, but does not scale well: traversing the elements of this Cartesian product linearly means first traversing all the way down the diagonal, which could be very long! So, we've ended up with a similar problem to the row-major traversal. Instead, I finally settled on a "tiling" Cartesian product: 
    
    
    cartesianProductTiling :: [a] -> [b] -> [(a, b)]
    cartesianProductTiling [] _ = []
    cartesianProductTiling _ [] = []
    cartesianProductTiling [a] [b] = [(a, b)]
    cartesianProductTiling as bs =
           cartesianProductTiling as1 bs1
        ++ cartesianProductTiling as2 bs1
        ++ cartesianProductTiling as1 bs2
        ++ cartesianProductTiling as2 bs2
      where
        (as1, as2) = splitAt ((length as) `div` 2) as
        (bs1, bs2) = splitAt ((length bs) `div` 2) bs

This splits the space into four quadrants and recursively applies itself to the upper-left, then lower-left, then upper-right, then lower-right, e.g., 
    
    
    *Main> cartesianProductTiling [1..4] [1..4]
    [(1,1),(2,1),(1,2),(2,2),(3,1),(4,1),(3,2),(4,2),(1,3),(2,3),(1,4),(2,4),(3,3),(4,3),(3,4),(4,4)]

![cp-tiling](https://dorchard.wordpress.com/wp-content/uploads/2019/08/cp-tiling-1.png) Thus, we explore the upper-left portion first, without having to traverse down a full row, column, or diagonal. This turned out to be much better for my purposes of searching the space of possible axioms for an algebraic structure. Note that this visits the elements in [Z-order](https://en.wikipedia.org/wiki/Z-order_curve) (also known as the Lebesgue space-filling curve) [Actually, it is a reflected Z-order curve, but that doesn't matter here]. The only downside to this tiling approach is that it does not work for infinite spaces (as it calculates the length of `as` and `bs`), so we cannot exploit Haskell's laziness here to help us in the infinite case. I'll leave it as an exercise for the reader to define a tiling version that works for infinite lists. Of course, there are many other possibilities depending on your application domain! 

* * *

Later edit: In the case of the example I mentioned, I actually do not need the full Cartesian product since the order of pairs was not relevant to me (equality is symmetric) and neither do I need the pairs of identical elements (equality is reflexive). So for my program, computing just the lower triangle of Cartesian product square is much more efficient, i.e,: 
    
    
    cartesianProductLowerTriangle :: [a] -> [b] -> [(a, b)]
    cartesianProductLowerTriangle as bs = concatMap (zip as) (tail (tails bs))

However, this does not have the nice property of tiling product where we visit the elements in a more balanced fashion. I'll leave that one for another day (I got what I needed from my program in the end anyway).
