---
layout: blog-post
title: "An afternoon of DTT/theorem provers: Agda and Coq"
date: "2015-03-02"
categories: [theorem provers]
excerpt: "Note from 23rd August, 2017 I found this draft blog post lying around, written in the spring of 2015 while I was working at Imperial College London as a Research Associate in the Mobility Reading Group with Nobuko Yoshida. This was the fruit of a discussion with Tiago Cogumbreiro where..."
wordpress_url: https://dorchard.wordpress.com/2015/03/02/an-afternoon-of-dtttheorem-provers-agda-and-coq/
---

**Note from 23rd August, 2017** I found this draft blog post lying around, written in the spring of 2015 while I was working at Imperial College London as a Research Associate in the [Mobility Reading Group](http://mrg.doc.ic.ac.uk/) with [Nobuko Yoshida](http://mrg.doc.ic.ac.uk/people/nobuko-yoshida/). This was the fruit of a discussion with [Tiago Cogumbreiro](http://cogumbreiro.github.io/) where we were comparing Coq and Agda for theorem proving. I believe we had a few more "side-by-side" comparisons written down, but this is all I have here: simple code for showing that addition of two even numbers yields an even number. It might prove to be a useful reference for someone else (at the time, I had a hard time remembering Coq syntax as I didn't use it very often, and Tiago kindly gave me some pointers) so I have posted it "as is" now, over two years later. 

* * *

Agda | Coq  
---|---  
      
    
    data Nat : Set where
      zero : Nat
      succ : Nat -> Nat
    
    data Even : Nat -> Set where
      even_base : Even zero
      even_step : forall {n} -> Even n -> Even (succ (succ n))
    

| 
    
    
    Inductive Nat :=
      | zero : Nat
      | succ : Nat -> Nat.
    
    Inductive Even: Nat -> Prop :=
      | even_base : Even zero
      | even_step : forall n, Even n -> Even (succ (succ n)).
      
      
    
    _+_ : Nat -> Nat -> Nat
    zero + n = n
    (succ n) + m = succ (n + m)
    

| 
    
    
    Fixpoint add (n:Nat) (m:Nat) :=
      match n with
        | zero => m
        | succ n' => succ (add n' m)
      end.
      
      
    
    even_sum : forall {n m} -> Even n -> Even m -> Even (n + m)
    even_sum even_base x      = x
    even_sum (even_step x) y  = even_step (even_sum x y)
    

| 
    
    
    Lemma add_succ:
      forall n m, add (succ n) m  = succ (add n m).
    Proof.
      auto.
    Qed.
    
    Lemma even_sum :
      forall n m, Even n -> Even m -> Even (add n m).
    Proof.
      intros n m even_n even_m.
      induction even_n.
       (* case even_base *)
       - simpl.
         assumption.
       (* case even_step *)
       - repeat (rewrite add_succ).
         apply even_step.
         assumption.
    Qed.
    
