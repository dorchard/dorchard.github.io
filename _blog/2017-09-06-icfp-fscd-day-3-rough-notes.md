---
layout: blog-post
title: "ICFP / FSCD day 3 - rough notes"
date: "2017-09-06"
categories: [conference notes]
excerpt: "(Blog posts for Day 1, Day 2, Day 3, Day 4 (half day)) I decided to take electronic notes at ICFP and FSCD (colocated) this year, and following the example of various people who put their conference notes online (which I've found useful), I thought I would attempt the same...."
wordpress_url: https://dorchard.wordpress.com/2017/09/06/icfp-fscd-day-3-rough-notes/
---

(Blog posts for [Day 1](https://dorchard.wordpress.com/2017/09/04/icfp-fscd-day-1-rough-conference-notes/), [Day 2](https://dorchard.wordpress.com/2017/09/05/icfp-fscd-day-2-rough-notes/), [Day 3](https://dorchard.wordpress.com/2017/09/06/icfp-fscd-day-3-rough-notes/), [Day 4](https://dorchard.wordpress.com/2017/09/07/fscd-day-4-rough-notes/) (half day)) I decided to take electronic notes at [ICFP](http://icfp17.sigplan.org/program/program-icfp-2017) and [FSCD](http://www.cs.ox.ac.uk/conferences/fscd2017/) (colocated) this year, and following the example of various people who put their conference notes online (which I've found useful), I thought I would attempt the same. However, there is a big caveat: my notes are going to be partial and may be incorrect; my apologies to the speakers for any mistakes. 

  * (ICFP) A Specification for Dependent Types in Haskell, Stephanie Weirich, Antoine Voizard, Pedro Henrique Avezedo de Amorim, Richard A. Eisenberg
  * (ICFP) Parametric Quantifiers for Dependent Type Theory Andreas Nuyts, Andrea Vezzosi, Dominique Devriese
  * (ICFP) - Normalization by Evaluation for Sized Dependent Types, Andreas Abel, Andrea Vezzosi, Theo Winterhalter
  * (ICFP) - A Metaprogramming Framework for Formal Verification, Gabriel Ebner, Sebastian Ullrich, Jared Roesch, Jeremy Avigad, Leonardo De Moura
  * (FSCD) - A Fibrational Framework for Substructural and Modal Logics, Dan Licata, Michael Shulman, Mitchell Riley
  * (FSCD) - Dinaturality between syntax and semantics, Paolo Pistone
  * (FSCD) - Models of Type Theory Based on Moore Paths, Andrew Pitts, Ian Orton
  * (ICFP) - Theorems for Free for Free: Parametricity, With and Without Types, Amal Ahmed, Dustin Jamner, Jeremy G. Siek, Philip Wadler
  * (ICFP) - On Polymorphic Gradual Typing, Yuu Igarashi, Taro Sekiyama, Atsushi Igarashi
  * (ICFP) - Constrained Type Families, J. Garrett Morris, Richard A. Eisenberg
  * (ICFP) - Automating Sized-Type Inference for Complexity Analysis, Martin Avanzini, Ugo Dal Lago
  * (ICFP) - Inferring Scope through Syntactic Sugar, Justin Pombrio, Shriram Krishnamurthi, Mitchell Wand



* * *

(ICFP) - **A Specification for Dependent Types in Haskell** , Stephanie Weirich, Antoine Voizard, Pedro Henrique Avezedo de Amorim, Richard A. Eisenberg Haskell already has dependent types! ish! (ICFP'14) But singletons are "gross"! (mock discussion between Stephanie and Richard). This work describes a semantics for dependent types in Haskell, along with a replacement for GHC's internal (Core) language, along with the high-level type theory and fully mechanized metatheory. But isn't Haskell already dependently typed? Cf Haskell indexed type for vectors. The following cannot be written in GHC at the moment: 
    
    
    vreplicate :: Pi(n :: Nat) -> Int -> Vec n
    vreplicate Zero _ = Nil
    vreplicate (Succ n) a = Cons a (vreplicate n a)

The reason this can't be typed is due to `n` being erased (after compilation, i.e., it doesn't appear in the run time) but it is needed dynamically in the first argument. In Dependent Haskell this can be done. But... it's not your usual system. For example, what about infinite data? 
    
    
    inf :: Nat
    inf = S inf
    vinf :: Vec inf
    vinf = Cons 2 vinf  -- yields equality demand Vec (S inf) = Vec inf

Idealized Haskell (IH) = System F_omega + GADTs (has uncediable type checking!) System FC (GHC Core) is a reified version of Idealized Haskell with enough annotations so that type checking is decidable, trivial, and syntax directed. Terms in Core can be see as type derivations of IH terms: contains type annotations and type equalities. (These can all be erased to get back into IH.) The first contribution of this work is a dependent System FC (DC). But its very complicated (needs also type soundness (progress/preservation), erasable coercions, ). Instead, they introduce System D, the dependently typed analog of Idealized Haskell: its a stripped down dependent Haskell in Curry style (implicit types) and similarly to IH its type checking is undecidable. It has dependent types, non-termination, and coercion abstraction. Coercion abstraction: for example 
    
    
    g : Int -> Int |- \v -> \c -> \v -> v : Pi n . (g n ~ 7) -> Vec (g n) -> Vec 7

Here the variable `v` (which has type `Vec (g n)` when passed in) is implicitly cast using the coercion `c` (which is passed in as a parameter) to `Vec 7`. This is translated into DC using an explicit coercion operator, applying `c` to coerce `v`. System D and System DC were mechanized (in Coq) during the design using Ott (to input the rules of the language) & LNgen (for generating lemmas). Currently working on dependent pattern matching, a full implementation in GHC, and roles. (Hence, this is the specification of the type system so far). Q: type inference for Dependent Haskell? A: Not sure yet (but see Richard Eisenberg's thesis) Q: How do you get decidable type checking in the presence of infinite terms? A: I didn't understand the answer (will followup later). Q: Why is coercion abstraction explicit in D while coercion application is implicit? A: "Coercion application *is* explicit in D, it's the use of coercion to cast a type that is implicit, but if you were to apply it to a value it would be explicit." 

* * *

(ICFP) - **Parametric Quantifiers for Dependent Type Theory** Andreas Nuyts, Andrea Vezzosi, Dominique Devriese A type variable is parameteric if is only used for type-checking (free well-behavedness theorems): i.e., can't be inspected by pattern matching so you have the same algorithm on all types, e.g. `flatten : forall X . Tree X -> List X`. Parametericity is well studied in the System F world. This work looks at parametericity in dependent type theory.; some results carry over, some can be proved internally, but some are lost. This work formulates a sound dependent type system ParamDTT which . Parametricity gives representation independence (in System F): $latex A \rightarrow B \cong (\forall X . (X \rightarrow A) \rightarrow (X \rightarrow B)$ (This result follows by parametricity, using the result that $latex g : \forall X . (X \rightarrow A) \rightarrow (X \rightarrow B)$ implies $latex g \, X_0 \, r_0 \, x\, = g \, A \, \textit{id} \, (r_0 \; x_0)$ which can be provided by relational parametricity, see Reynolds "related things map to related things", applies identity extension lemma). Can we do the same thing for DTT and can we prove the result internally? $latex \Pi$ is however not parametric. For example if we convert to $latex \Pi (X : U) . (X \rightarrow A) \rightarrow (X \rightarrow B)$. Suppose $B = U$ then we can leak details of the implementation (rerepresentation type is returned as data) $latex \textit{leak} \; X \; r \; x = X$ (has this type). This violates the identity extension lemma used in the above proof for System F. So instead, **add** a parametric quantifier to DTT to regain representation independence, making the above $latex \textit{leak}$ ill typed. The proof of parametricity for $latex g : \forall X . (X \rightarrow A) \rightarrow (X \rightarrow B)$ can now be proved internally. This uses the relational interval type $latex 0 -- 1 : \mathbb{I}$ (cf Bernardy, Coquand, and Moulin 2015, on bridge/path-based proofs) which gives a basis for proving the core idea of "related things map to related things" where $latex 0$ is connected with the type $latex X$ (in the above type) and $latex 1$ is connected to the type $latex A$ via a switching term $latex / r/ : \mathbb{I} \rightarrow U$ (see paper for the proof) (I think this is analogous to setting up a relation between $latex X$ and $latex A$ in the usual relational parametricity proof). They extended Agda with support for this. 

* * *

(ICFP) - **Normalization by Evaluation for Sized Dependent Types** Andreas Abel, Andrea Vezzosi, Theo Winterhalter (context, DTT a la Martin-Lof, and you can add subtpying to this, where definitional equality implies subtyping). Definitional equality is decideable (for the purposes of type checking), but the bigger the better (want to be able to know as many things equal as possible). Termination is needed for consistency, general `fix` gives you inconsistency. Instead, you can used data types indexed by tree height, where $latex \textsf{Nat}^i = \\{ n \mid n < i\\}$, you can define $latex \textsf{fix} : (\forall i \rightarrow (\textsf{Nat}^{i} \rightarrow C) \rightarrow (\textsf{Nat}^{i+1} \rightarrow C)) \rightarrow \forall j \rightarrow \textsf{Nat}^j \rightarrow C$. However, size expressions _are not unique,_ which is problematic for proofs. e.g., $latex suc i : \textsf{Nat}^i \rightarrow \textsf{Nat}^\infty$ but also $latex suc \infty : \textsf{Nat}^i \rightarrow \textsf{Nat}^\infty$. Intuition: sizes are irrelevant in terms, but relevant in types only. Andreas set up some standard definitions of inductive `Nat` then tried to define a Euclidean division on `Nat` (where `monus` is minus cutting off at `0`). 
    
    
    div : Nat → Nat → Nat
    div zero y = zero
    div (suc x) y = {! suc (div (monus x y) y) !}

However, Agda fails to termination check this. The solution is to "size type"-up everything, i.e., redefine the usual inductive `Nat` to have a size index: 
    
    
    data Nat : Size → Set where
     zero : ∀ i → Nat (↑ i)
     suc : ∀ i → Nat i → Nat (↑ i)

All the other definitions were given sized type parameters (propogated through) and then `div` was redefined (type checking to): 
    
    
    div : ∀ i → Nat i → Nat ∞ → Nat i
    div .(↑ i) (zero i) y = zero i
    div .(↑ i) (suc i x) y = suc _ (div i (monus i _ x y) y)

So far this is the usual technique. However, now we have difficulty proving a lemma (which was straightforward before sizing that minus of `x` with itself gives `0`. Now this looks like: 
    
    
    monus-diag : ∀ i (x : Nat i) → Eq ∞ (monus i i x x) (zero ∞)

In the case: `monus-diag .(↑ i) (suc i x) = monus-diag i x` Agda gets the error `i != ↑ i of type Size`. In the Church-style, dependent type functions = polymorphic functions, so you can't have irrelevant arguments. In Curry-style (with forall) this is okay. (see the previous talk, this could be a possible alternate solution?) Instead, we want "Churry"-style where size arguments are used for type checking but can be ignored during equality checking: thus we want typing rules for irrelevant sizes. This was constructed via a special "irrelevant" modality $latex \bullet$, where sizes uses as indexes can be marked as irrelevant in the context. Here is one of the rules for type formation when abstracting over an irrelevantly typed argument: $latex \dfrac{\Gamma \vdash A : Type \quad \Gamma, \bullet \bullet x : A \vdash B : \textsf{type}}{\Gamma \vdash (x : \bullet A) \rightarrow B : \textsf{type}}$ This seemed to work really nicely (I couldn't get all the details down, but the typing rules were nice and clean and made a lot of sense as a way of adding irrelevancy).

* * *

(ICFP) - **A Metaprogramming Framework for Formal Verification** Gabriel Ebner, Sebastian Ullrich, Jared Roesch, Jeremy Avigad, Leonardo De Moura (Context: Lean is a dependently-typed theorem prover that aims to bridge the gap between interactive and automatic theorem proving. It has a very small trusted kernel (no pattern matching and termination checking), based on Calculus of Inductive Constructions + proof irrelevance + quotient types.) They want to extend Lean with tactics, but its written in C++ (most tactic approaches are defined internally, cf Coq). Goal: to extend Lean using Lean by making Lean a reflective metaprogramming language (a bit like Idris) does, in order to build and run tactics within Lean. Do this by exposing Lean internals to Lean (Unification, type inference, type class resolution, etc.). Also needed an efficient evaluator to run meta programs. 
    
    
    lemma simple (p q : Prop) (hp : p) (hq : q) : q := 
    by assumption

Assumption is a tactic, a meta program in the `tactic` monad: 
    
    
    meta def assumption : tactic unit := do
      ctx <- local_context,
      t   <- target
      h   <- find t ctx,
      exact h

(seems like a really nice DSL for building the tactics). Terms are reflected so there is a meta-level inductive definition of Lean terms, as well as quote and unquote primitives built in, but with a shallow (constant-time) reflection and reification mechanism. The paper shows an example that defines a robust simplifier that is only about 40 locs (applying a congruence closure). They built a bunch of other things, including a bigger prover (~3000 loc) as well as command-line VM debugger as a meta program (~360 loc). Next need a DSL for actually working with tactics (not just defining them). Initially quite ugly (with lots of quoting/unquoting). So to make things cleaner they let the tactics define their own parsers (which can then hook into the reflection mechanism). They then reused this to allow user-defined notations. 

* * *

(FSCD) **A Fibrational Framework for Substructural and Modal Logics,** Dan Licata, Michael Shulman, Mitchell Riley Background/context: model logic core $latex \dfrac{\emptyset \vdash A}{\Gamma \vdash \Box A}$ for necessity (true without any hypotheses) $latex \dfrac{\Gamma \vdash \Diamond A}{\Diamond \Gamma \vdash \Diamond B}$ (if something A is possible true then possibility can propagate to the context-- doesn't change the "possibleness"). Various intuitionistic substructural and modal logics/type systems: linear/affine, relevant, ordered, bunched (separation logic), coeffects, etc. Cohesive HoTT: take dependent type theory and add modalities (int, sharp, flat). S-Cohesion (Finster, Licata, Morehouse, Riley: a comonad and monad that themselves are adjoint, ends up with two kind of products which the modality maps between). Motivation: what are the common patterns in substructural and modal logics? How do we construct these things more systematically from a a small basic calculus. With S4 modality (in sequent calculus), its common to make two contexts, one of modality formulae and one of normal, e.g., $latex \Gamma; \Delta \vdash A$ which is modelled by $latex \Box \Gamma \times \Delta \rightarrow A$. In the sequent calculus style, use the notion of context to form the type. Linear logic ! is similar (but with no weakening). The rules for $latex \otimes$ follow the same kind of pattern: e.g., $latex \dfrac{\Gamma, A, B \vdash C}{\Gamma, A\otimes B \vdash C}$ where the context "decays" into the logical operator (rather than being literally equivalent): the types inherent the properties of the context (cf. also exchange). _The general pattern: operations on contexts, with explicit or admissible structure properties, then have a type constructor (an operator) that internalises the implementation and inherits the properties._ This paper provides a framework for doing this, and abstracting the common aspects of many intuitionistic substructural and modal logicas based on a sequent calculus (has cut elimination for all its connectives, equational theory, and categorical semantics). Modal operators are decomposed in the same way as adjoint linear logic (Benton&Wadler;'94), see also Atkey's lambda-calculus for resource logic (2004) and Reed (2009). So.. how? Sequents are completely Cartesian but are annotated with a description of the context and its properties/substructurality by a first order term (a context descriptor) $latex \Gamma \vdash_a A$ where $latex a$ is this context descriptor. Context descriptors are built on "modes". e.g., $latex a: A, b : B, c : C, d : D \vdash_{(a \otimes b) \otimes (c \otimes d)} X$ the meaning of this sequent depends on the equations/inequations on the context descriptor:, e.g.,if you have associativity of $latex \otimes$ you get ordered logic, if you have contraction $latex a \Rightarrow a \otimes a$ then you get a relevant logic, etc. Bunched implication will have two kinds of nodes in the context descriptor. For a modality, unary function symbols, e.g. $latex \textbf{r}(a) \otimes b$ means that the left part of the context is wrapped by a modality. A subtlety of this is "weakening over weakening", e.g., $latex \dfrac{\Gamma \vdash_a B}{\Gamma, x : A \vdash_a B}$ where we have weakend in the sequent calculus but the context descriptor is unchanged (i.e., we can't use $latex x : A$ to prove $latex B$). The F types give you a product structured according to a context descriptor, e.g. $latex A \otimes B := F_{x \otimes y} (x : A, y : B)$. All of the left rules become instances of one rule on F: $latex \dfrac{\Gamma, \Delta \vdash_{\beta[\alpha / x]} B}{\Gamma, x : F_\alpha(\Delta) \vdash B}$ which gives you all your left-rules (a related dual rule gives the right sequent rules). Categorical semantics is based on a cartesian 2-multicategory (see paper!) Q: is this like display logics? Yes in the sense of "punctuating" the shape of the context, but without the "display" (I don't know what this means though). This is really beautiful stuff. It looks like it could extend okay with graded modalities for coeffects, but I'll have to go away and try it myself. 

* * *

(FSCD) - **Dinaturality between syntax and semantics** , Paolo Pistone Multivariate functions $latex F X X$ and $latex G Y Y$ where the first parameter is contravariant and second is covariant may have _dinatural transformations_ between them. (Dinaturality is weaker than naturality). Yields a family of maps $latex \theta_X \in Hom_C(F X X, G X X)$ which separate the contravariant and covariant actions in the coherence condition (see [Wiki](https://en.wikipedia.org/wiki/Dinatural_transformation) for the hexagonal diagram which is the generalisation of the usual naturality property into the dinatural setting). A standard approach in categorical semantics is to interpret open formula by multivariant functor $latex F X Y = X \rightarrow Y$ and proofs/terms by dinautral transformations. Due to Girard, Scedrov, Scott 1992 there is the theorem that: if $latex M$ is closed and $latex \vdash M : \sigma$ then $latex M$ is dinatural. The aim of the paper is to _prove the converse result_ : if $latex M$ is closed and $latex \beta\eta$-normal and (syntactically) dinatural then $latex \vdash M : \sigma$ (i.e., implies typability). Syntactic dinaturality examples where shown (lambda terms which exhibit the dinaturality property). Imagine a transformation on a Church integer $latex (X \rightarrow X) \xrightarrow{h} (X \rightarrow X)$- this is a dinatural transformation and its dinaturality hexagon is representable by lambda terms. (I didn't get a chance to grok all the details here and serialise them). Typability of a lambda term was characterised by its tree structure and properties of its shape and size (e.g., $latex \lambda x_1 . \ldots \lambda x_n . M : \sigma_1 \rightarrow \ldots \sigma_h \rightarrow \tau$ then $n \leq h$, there are various others; see paper).  The theorem then extends from typability to parametricity (implies that the syntactically dinatural terms are parametric) when the type is "interpretable" (see paper for definition). (sorry my notes don't go further as I got a bit lost, entirely my fault, I was flagging after lunch). 

* * *

(FSCD) - **Models of Type Theory Based on Moore Paths** , Andrew Pitts, Ian Orton In MLTT (Martin-Lof Type Theory), univalence is an extensional property (e.g., $latex (\forall x . f x = g x) \rightarrow (f = g)$) of types in a universe $latex U$: given $latex X, Y : U$ every identification $latex p : Id_U X Y$ induces an (Id)-isomorphism $latex X \cong Y$. U is univalent "if all Id-isomorphisms $latex X \cong Y$ is U are induced by some identification $latex P : Id_U X Y$" (want this expressed in type theory) (this is a simpler restating of Voevodsky's original definition due to Licata, Shulman, et al.). This paper: towards answering, are there models for usual type theory which contain such univalent universes? Univalence is inconsistent with extensional type theory where $latex p : Id_A X Y$ implies $latex x = y \wedge p = \textsf{refl}$. Univalence is telling you that the notion of identification is richer subsuming ETT where there is an identification between two types then they are already equal, which is much smaller/thinner. Need a source of models of "intensional" identification types (i.e., not the extensional ones ^^^): homotopy type theory provides a source of such models via paths: $latex p : Id_A x y$ are paths from point $latex x$ to point $latex y$ in a space $latex A$ where $latex \textsf{refl}_A$ is a "constant path" (transporting along such a path does nothing to the element). So we need to find some structure $latex Path_A x y$ for these identifications, but we need to restrict to families of type $latex (B \; x \mid x : A)$ carrying structure to guarantee substitution operations (in this DTT context). "Holes" is diagrams are filled using path reversals and path composition. Solution is "Moore" paths. A Moore path from $latex x$ to $latex y$ in a topological space $latex X$ is specified by a shape (its length) $latex |p|$ in $latex \mathbb{R}_+$ and an extent function $latex p@ : \mathbb{R}_+ \rightarrow X$ satisfying $latex p@ 0 = x$ and $latex (\forall i \geq |p|) . p@i = y$. These paths have a reversal operator by truncated subtraction $latex \textit{rev}(p@i) = p@(|p| - i)$. (note this is idempotent on constant paths as required, allowing holes in square paths to be filled (I had to omit the details, too many diagrams)). But topological spaces don't give us a model of MLTT, so they replace it by an arbitrary topos (modelling extensional type theory) and instead of $latex \mathbb{R}$ for path length/shape use any totally ordered commutative ring. All the definition/properties of Moore paths are the expressed in the internal language of the topos. This successfully gives you a category with families (see Dybjer) modelling intensional Martin-Lof type theory (with Pi). This also satisfies  _dependent functional extensionality_ thus its probably a good model as univalence should imply extensionality. But haven't yet got a proof that this does contain a univalence universe (todo). Q: can it just be done with semirings? Yes. 

* * *

(ICFP) - **Theorems for Free for Free: Parametricity, With and Without Types,** Amal Ahmed, Dustin Jamner, Jeremy G. Siek, Philip Wadler Want gradual typing AND parametricity. There has been various work integrating polymorphic types and gradual typing (with blame) but so far there have been no (published) proofs of parametricity. This paper proposes a variant of the polymorphic blame calculus $latex \lambda B$ [Ahmed, Findler, Siek, Wadler POPL'11] (fixed a few problems) and proves parametricity for it. Even dynamically typed code cast to universal type should behave parametrically., e.g. consider the increment function which is typed dynamically and cast to a parametric type $latex \lambda x . x + 1 : \ast \Rightarrow^p \forall X . X \rightarrow X) [int] 4$ returns 5 but we want to raise a "blame" for the coercion $latex p$ here (coercing a monomorphic to polymorphic type is bad!). The language has coercions and blame, and values can be tagged with a coercion (same for function values). Some rules: $latex (v : G \Rightarrow^p \ast \Rightarrow^q G) \mapsto v$ (that is, casts to the dynamic type and back again cancel out). But, if you cast to a different type (tag) then blame pops out: $latex (v : G \Rightarrow^p \ast \Rightarrow^q G') \mapsto \textsf{blame} p$ (or maybe that was blame q?) $latex add = \Lambda X . \lambda (x : X) . 3 + (x : X \Rightarrow^p \ast \Rightarrow^q \textsf{int})$ this has a type that makes it look like a constant function $latex \lambda X . X \rightarrow \textsf{int}$. When executing this we want to raise blame rather than actually produce a value (e.g. for $latex add 3 [\textsf{int}] 2$). Solution: use runtime type generation rather than substitution for type variables. A type-name store $latex \Sigma$ provides a dictionary mapping type variables to types. $latex \Sigma \rhd (\Lambda X . v) [B] \mapsto \Sigma, \alpha := B \rhd v[\alpha/X]$ i.e., instead of substituting the $latex B$ in the application, create a fresh type name $latex \alpha$ that is then mapped to $latex B$ in the store. Then we extend this with types and coercion: $latex \Sigma \rhd (\Lambda X . v) [B] \mapsto \Sigma, \alpha := B \rhd v[\alpha/X] : A[\alpha/X] \Rightarrow^{+\alpha} A[B/X]$ where $latex +\alpha$ (I think!) means replace occurrences of B with $latex \alpha$. Casts out a polymorphic type are instantiated with the dynamic type. Casts into polymorphic types are delayed like function casts. Parametricity is proved via step-indexed Kripke logical relations. The set of worlds $latex W$ are tuples of the type-name stores, and relations about when concealed values should be related. See paper: also shows soundness of the logical relations wrt. contextual equivalence. There was some cool stuff with "concealing" that I missed really. 

* * *

(ICFP) - **On Polymorphic Gradual Typing** , Yuu Igarashi, Taro Sekiyama, Atsushi Igarashi Want to smoothly integrate polymorphism/gradual. e.g., apply dynamically-typed arguments into polmorphically typed parameters, and vice versa. Created two systems: System Fg (polymorphic gradually typed lambda cal) which translates to System Fc. Want conservativity: A non-dynamically typed term in System F should be convertible into System Fg, and vice versa. The following rule shows the gradual typing "consistency" rule for application (in System Fg and gradual lambda calculus): $latex \dfrac{\Gamma \vdash s : T_{11} \rightarrow T_{12} \quad \Gamma \vdash t : T_1 \quad T_1 \sim T_{11}}{\Gamma \vdash s \; t : T_2}$ where $latex \sim$ defines type consistency. Idea: extend this to include notions of consistency between polymorphic and dynamic types. An initial attempt breaks conservativity since there are ill-typed System F terms which are well-typed in System Fg then. The gradual guarantee conjecture: coercions without changes to the operational semantics. They introduce "type precision" (which I think replaces consistency) which is not symmetric where $latex A \sqsubseteq \ast$ - I didn't yet get the importance of this asymmetry). But there are some issues again... a solution is to do fresh name generation to prevent non-parametric behaviour (Ahmed et al. '11, '17 **the last talk**) But making types less precise still changes behaviour (create blame exceptions). Their approach to fix this is to restrict the term precision relation $latex \sqsubseteq$ so that it can not be used inside of $latex \Lambda$ (term level) and $latex \forall$ (type level). Still need to prove the gradual guarantee for this new approach (and adapt the parametricity results from Ahmed et al. '17). 

* * *

(ICFP) - **Constrained Type Families** , J. Garrett Morris, Richard A. Eisenberg (Recall type families = type-level functions) Contribution 1: Discovery: GHC assumes that all type families are total Contribution 2: First type-safety proof with non-termination and non-linear patterns Contribution 2.5 (on the way): simplified metatheory The results are applicable to any language with partiality and type-level functions (e.g. Scala) (Haskellers leave no feature unabused!) 
    
    
    -- Example type family:
    
    type family Pred n
    type instance Pred (S n) = n
    type instance Pred Z = Z

Can define a closed version: 
    
    
    type family Pred n where
                Pred (S n) = n
                Pred Z = Z

Definition: A ground type has no type families. Definition: A total type family, when applied to ground types, always produces a ground type. In the new proposal: all partial type families must be associated type families.
    
    
    type family F a                 -- with no instances
    x = fst (5, undefined :: F Int) -- is typeable, but there are no instance of F!

Instead, put it into a class: 
    
    
    class CF a where
        type F a
    x = fst (5, undefined :: F Int) -- now get error "No instance for (CF Int)"

Can use closed type families for type equality. 
    
    
    type family EqT a b where
           EqT a a = Char
           EqT a b = Bool
    f :: a -> EqT a (Maybe a) -- This currently fails to type check but it should work
    f _ = False

Another example: 
    
    
    type family Maybes a 
    type instance Maybes a = Maybe (Maybes a)
    justs = Just justs -- GHC says we can't have an infinite type a ~ Maybe a
    -- But we clearly do with this type family!

Why not just ban ​`Maybes`? Sometimes we need recursive type families. By putting (partial) type classes inside a class means we are giving a constraint that explains there should be a type at the bottom of (once we've evaluated) a type family. Therefore we escape the totality trap and avoid the use of bogus types. Total type families need not be associated. Currently GHC has a termination checker, but it is quite weak, so often people turn it off with `UndecideableInstances`. But, wrinkle: backwards compatibility (see paper) (lots of partial type families that are not associated). Forwards compatibility: dependent types, terminating checking, is Girard's paradox encodable? This work also lets us simplify injective type family constraints (this is good, hard to understand at the moment). It makes closed type families more powerful (also great). 

* * *

(ICFP) - **Automating Sized-Type Inference for Complexity Analysis** , Martin Avanzini, Ugo Dal Lago (for higher-order functional programs automatically). Instrument a program with a step counter by turning them into state monad which gives a dynamic count. Sized typed (e.g., sized vectors), let you type 'reverse' of a list as $latex \forall i . L_i \, a \rightarrow L_i \, a$. But inference is highly non-trivial. Novel sized-type system with polymorphic recursion and arbitrary rank polymorphism on sizes with **inference procedure** for the size types. Constructor definitions define size measure, e.g., for lists of nats: $latex \textsf{nil} : L_1$ and $latex \textsf{cons} : \forall i j . N_i \rightarrow L_j \rightarrow L_{i + j + 1}$ (here the natural number has a size too). Can generalise size types in the application rules, (abs, app, and var rules deal with abstraction and instantiation of size parameters). Theorem (soundness of sizes): (informally) the sizes attached to the a well-typed program gives you a bound on the number of execution steps that actually happen dynamically (via the state encoding). [also implies termination]. Inference step 1: add template annotations, e.g., $latex \textit{reverse} : \forall k . L_k \rightarrow L_{g(k)}$. Then we need to find a concrete interpretation of $latex g$. Step 2: constraint generation, which arise from subtyping which approximate sizes, plus the constructor sizes. These collect together to constraint the meta variables introduced in step 1. Step 3: constraint solving: replace meta variable by Skolem terms. Then use an SMT solver (the constraints are non-linear integer constraints). (from a question) The solution may not be affine (but if it is then it is easier to find). The system does well at inferring the types of lots of standard higher-order functions with lists. But cross product on lists produces a type which is too polymorphic: with a little more annotation you can give it a useful type. Q: What happens with quicksort? Unfortunately it can't be done in the current system. Insertion sort is fine though. Q: What about its relation to RAML? The method is quite different (RAML uses an amortized analysis). The examples that each can handle are quite different. (ICFP) - **Inferring Scope through Syntactic Sugar** , Justin Pombrio, Shriram Krishnamurthi, Mitchell Wand [[Github](https://github.com/brownplt/scope-graph)] Lots of languages use syntactic sugar, but then its hard to understand what the scoping rules are for these syntactic sweets. E.g. list comprehension `[e | p <- L]` desugars to `map (\p . e) L`. The approach in this work is a procedure of scope inference which takes these rewrite patterns (where `e` and `p` and `L` are variables/parameters). We know the scoping rules for the core language (i.e., the binding on the right) [which parameterises the scope inference algorithm]. Desugaring shouldn't change scope (i.e., if there is path between two variables then it should be preserved). So the scope structure is homomorphic to the desugared version, but smaller. (A scope preorder was defined, I didn't get to write down the details). Theorem: if resugaring succeeds, then desugaring will preserve scope. Evaluation: the techniques was tested on Pyret (educational language), Haskell (list comprehensions), and Scheme (all of the binding constructs in R5RS). It worked for everything apart from 'do' in R5RS.
