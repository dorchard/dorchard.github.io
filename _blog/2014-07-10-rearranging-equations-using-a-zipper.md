---
layout: blog-post
title: "Rearranging equations using a zipper "
date: 2014-07-10
categories: [haskell, maths]
excerpt: "Whilst experimenting with some ideas for a project, I realised I needed a quick piece of code to rearrange equations (defined in terms of +, *, -, and /) in AST form, e.g., given an AST for the equation x = y + 3, rearrange to get y = x..."
wordpress_url: https://dorchard.wordpress.com/2014/07/10/rebalancing-equations-using-a-zipper/
---

Whilst experimenting with some ideas for a project, I realised I needed a quick piece of code to rearrange equations (defined in terms of +, *, -, and /) in AST form, e.g., given an AST for the equation `x = y + 3`, rearrange to get `y = x - 3`.

I realised that equations can be formulated as _zippers_ over an AST, where operations for navigating the zipper essentially rearrange the equation. I thought this was quite neat, so I thought I would show the technique here. The code is in simple Haskell.

I'll show the construction for a simple arithmetic calculus with the following AST data type of terms:
    
    
    data Term = Add Term Term 
              | Mul Term Term 
              | Div Term Term
              | Sub Term Term  
              | Neg Term
              | Var String
              | Const Integer
    

with some standard pretty printing code:
    
    
    instance Show Term where 
        show (Add t1 t2) = (show' t1) ++ " + " ++ (show' t2)
        show (Mul t1 t2) = (show' t1) ++ " * " ++ (show' t2)
        show (Sub t1 t2) = (show' t1) ++ " - " ++ (show' t2)
        show (Div t1 t2) = (show' t1) ++ " / " ++ (show' t2)
        show (Neg t) = "-" ++ (show' t) 
        show (Var v) = v
        show (Const n) = show n
    

where `show'` is a helper to minimise brackets e.g. pretty printing "-(v)" as "-v".
    
    
    show' :: Term -> String
    show' (Var v) = v
    show' (Const n) = show n
    show' t@(Neg (Var v)) = show t
    show' t@(Neg (Const n)) = show t
    show' t = "(" ++ show t ++ ")"
    

Equations can be defined as pairs of terms, i.e., 'T1 = T2' where T1 and T2 are both represented by values of `Term`. However, instead, I'm going to represent equations via a zipper. 

Zippers (described beautifully in [the paper by Huet](http://www.st.cs.uni-sb.de/edu/seminare/2005/advanced-fp/docs/huet-zipper.pdf)) represent values that have some subvalue "in focus". The position of the focus can then be shifted through the value, refocussing on different parts. This is encoded by pairing a focal subvalue with a _path_ to this focus, which records the rest of the value that is not in focus. For equations, the zipper type pairs a focus `Term` (which we'll think of as the left-hand side of the equation) with a path (which we'll think of as the right-hand side of the equation).
    
    
    data Equation = Eq Term Path
    

Paths give a sequence of direction markers, essentially providing an address to the term in focus, starting from the root, where each marker is accompanied with the label of the parent node and the subtree of the branch not taken, i.e., a path going left is paired with the right subtree (which is not on the path to the focus).
    
    
    data Path = Top (Either Integer String)  -- At top: constant or variable
               | Bin Op                -- OR in a binary operation Op,
                     Dir               --    in either left (L) or right (R) branch
                     Term              --    with the untaken branch 
                     Path              --    and the rest of the equation
               | N Path                -- OR in the unary negation operation
    
    data Dir = L | R 
    data Op = A | M | D | S | So | Do
    

The `Op` type gives tags for every operation, as well as additional tags `So` and `Do` which represent sub and divide but with arguments flipped. This is used to get an isomorphism between the operations that zip "up" and "down" the equation zipper, refocussing on subterms.

A useful helper maps tags to their operations:
    
    
    opToTerm :: Op -> (Term -> Term -> Term)
    opToTerm A = Add
    opToTerm M = Mul
    opToTerm D = Div
    opToTerm S = Sub
    opToTerm So = (\x -> \y -> Sub y x)
    opToTerm Do = (\x -> \y -> Div y x)
    

Equations are pretty printed as follows:
    
    
    instance Show Path where
        show p = show . pathToTerm $ p
        
    instance Show Equation where
        show (Eq t p) = (show t) ++ " = " ++ (show p)
    

where `pathToTerm` converts paths to terms:
    
    
    pathToTerm :: Path -> Term
    pathToTerm (Top (Left c)) = Const c
    pathToTerm (Top (Right v))= Var v
    pathToTerm (Bin op L t p) = (opToTerm op) (pathToTerm p) t
    pathToTerm (Bin op R t p) = (opToTerm op) t (pathToTerm p)
    pathToTerm (N p)          = Neg (pathToTerm p)
    

Now onto the zipper operations which providing rebalancing of the equation. Equations are zipped-down by `left` and `right`, which for a binary operation focus on either the left or right argument respectively, for unary negation focus on the single argument, and for constants or variables does nothing. When going left or right, the equations are rebalanced with their inverse arithmetic operations (show in the comments here): 
    
    
    left (Eq (Var s) p)     = Eq (Var s) p
    left (Eq (Const n) p)   = Eq (Const n) p
    left (Eq (Add t1 t2) p) = Eq t1 (Bin S L t2 p)   -- t1 + t2 = p  -> t1 = p - t2
    left (Eq (Mul t1 t2) p) = Eq t1 (Bin D L t2 p)   -- t1 * t2 = p  -> t1 = p / t2
    left (Eq (Div t1 t2) p) = Eq t1 (Bin M L t2 p)   -- t1 / t2 = p  -> t1 = p * t2
    left (Eq (Sub t1 t2) p) = Eq t1 (Bin A L t2 p)   -- t1 - t2 = p  -> t1 = p + t2
    left (Eq (Neg t) p)     = Eq t (N p)             -- -t = p       -> t = -p
    
    right (Eq (Var s) p)     = Eq (Var s) p          
    right (Eq (Const n) p)   = Eq (Const n) p
    right (Eq (Add t1 t2) p) = Eq t2 (Bin So R t1 p)  -- t1 + t2 = p -> t2 = p - t1
    right (Eq (Mul t1 t2) p) = Eq t2 (Bin Do R t1 p)  -- t1 * t2 = p -> t2 = p / t1
    right (Eq (Div t1 t2) p) = Eq t2 (Bin D R t1 p)   -- t1 / t2 = p -> t2 = t1 / p
    right (Eq (Sub t1 t2) p) = Eq t2 (Bin S R t1 p)   -- t1 - t2 = p -> t2 = t1 - p
    right (Eq (Neg t) p)     = Eq t (N p)
    

In both `left` and `right`, `Add` and `Mul` become subtraction and dividing, but in `right` in order for the the zipping-up operation to be the inverse, subtraction and division are represented using the flipped `So` and `Do` markers.

Equations are zipped-up by `up`, which unrolls one step of the path and reforms the term on the left-hand side from that on the right. This is the inverse of `left` and `right`:
    
    
    up (Eq t1 (Top a))        = Eq t1 (Top a)
    up (Eq t1 (Bin A L t2 p)) = Eq (Sub t1 t2) p -- t1 = t2 + p -> t1 - t2 = p
    up (Eq t1 (Bin M L t2 p)) = Eq (Div t1 t2) p -- t1 = t2 * p -> t1 / t2 = p
    up (Eq t1 (Bin D L t2 p)) = Eq (Mul t1 t2) p -- t1 = p / t2 -> t1 * t2 = p
    up (Eq t1 (Bin S L t2 p)) = Eq (Add t1 t2) p -- t1 = p - t2 -> t1 + t2 = p
    
    up (Eq t1 (Bin So R t2 p)) = Eq (Add t2 t1) p -- t1 = p - t2 -> t2 + t1 = p
    up (Eq t1 (Bin Do R t2 p)) = Eq (Mul t2 t1) p -- t1 = p / t2 -> t2 * t1 = p
    up (Eq t1 (Bin D R t2 p))  = Eq (Div t2 t1) p -- t1 = t2 / p -> t2 / t1 = p
    up (Eq t1 (Bin S R t2 p))  = Eq (Sub t2 t1) p -- t1 = t2 - p -> t2 - t1 = p
    
    up (Eq t1 (N p))           = Eq (Neg t1) p    -- t1 = -p     -> -t1 = p
    

And that's it! Here is an example of its use from GHCi.
    
    
    foo = Eq (Sub (Mul (Add (Var "x") (Var "y")) (Add (Var "x") 
               (Const 1))) (Const 1)) (Top (Left 0))
    
    *Main> foo
    ((x + y) * (x + 1)) - 1 = 0
    
    *Main> left $ foo
    (x + y) * (x + 1) = 0 + 1
    
    *Main> right . left $ foo
    x + 1 = (0 + 1) / (x + y)
    
    *Main> left . right . left $ foo
    x = ((0 + 1) / (x + y)) - 1
    
    *Main> up . left . right . left $ foo
    x + 1 = (0 + 1) / (x + y)
    
    *Main> up . up . left . right . left $ foo
    (x + y) * (x + 1) = 0 + 1
    
    *Main> up . up . up . left . right . left $ foo
    ((x + y) * (x + 1)) - 1 = 0
    

It is straightforward to prove that: `up . left $ x = x` (when `left x` is not equal to `x`) and `up . right $ x = x`(when `right x` is not equal to `x`). 

Note, I am simply rebalancing the syntax of equations: this technique does not help if you have multiple uses of a variable and you want to solve the question for a particular variable, e.g. y = x + 1/(3x), or quadratics.

Here's a concluding thought. The navigation operations `left`, `right`, and `up` essentially apply the inverse of the operation in focus to each side of the equation. We could therefore reformulate the navigation operations in terms of any _group_ : given a term `L ⊕ R` under focus where `⊕` is the binary operation of a group with inverse operation `-1`, then navigating left applies `⊕ R-1` to both sides and navigating right applies `⊕ L-1`. However, in this blog post there is a slight difference: navigating applies the inverse to both sides and then reduces the term of the left-hand side using the group axioms `X ⊕ X-1 = I` (where `I` is the identity element of the group) and `X ⊕ I = X` such that the term does not grow larger and larger with inverses. 

I wonder if there are other applications, which have a group structure (or number of interacting groups), for which the above zipper approach would be useful?
