chapter {* Generated by Lem from multimap.lem. *}

theory "Multimap" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_set" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_function" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_maybe" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_assert_extra" 
	 "Show" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_set_extra" 
	 "Missing_pervasives" 

begin 

(*open import Bool*) 
(*open import Basic_classes*) 
(*open import Maybe*) 
(*open import Function*) 
(*open import Num*) 
(*open import List*)
(*open import Set*)
(*open import Set_extra*)
(*open import Assert_extra*)
(*open import Missing_pervasives*)
(*open import String*)
(*open import Show*)

(* HMM. Is the right thing instead to implement multiset first? Probably. *)

(* This is a set of pairs
 * augmented with operations implementing a particular kind of 
 * map.
 * 
 * This map differs from the Lem map in the following ways.
 * 
 * 0. The basic idea: it's a multimap, so a single key, supplied as a query,
 *    can map to many (key, value) results.
 *    But PROBLEM: how do we store them in a tree? We're using OCaml's
 *    Set implementation underneath, and that doesn't allow duplicates.
 * 
 * 1. ANSWER: require keys still be unique, but that the user supplies an 
 *    equivalence relation on them, which
 *    is coarser-grained than the ordering relation
 *    used to order the set. It must be consistent with it, though: 
 *    equivalent keys should appear as a contiguous range in the 
 *    ordering.
 * 
 * 2. This allows many non-equal keys, hence present independently
 *    in the set of pairs, to be equivalent for the purposes of a 
 *    query.
 * 
 * 3. The coarse-grained equivalence relation can be supplied on a 
 *    per-query basis, meaning that different queries on the same
 *    set can query by finer or coarser criteria (while respecting 
 *    the requirement to be consistent with the ordering).
 * 
 * Although this seems more complicated than writing a map from 
 * k to list (k, v), which would allow us to ditch the finer ordering, 
 * it scales better (no lists) and allows certain range queries which 
 * would be harder to implement under that approach. It also has the 
 * nice property that the inverse multimap is represented as the same
 * set but with the pairs reversed.
 *)

type_synonym( 'k, 'v) multimap =" ('k * 'v) set "

(* In order for bisection search within a set to work, 
 * we need the equivalence class to tell us whether we're less than or
 * greater than the members of the key's class. 
 * It effectively identifies a set of ranges. *)
type_synonym 'k key_equiv =" 'k \<Rightarrow> 'k \<Rightarrow> bool "

(*
val hasMapping : forall 'k 'v. key_equiv 'k -> multimap 'k 'v -> bool
let inline hasMapping equiv m =
*)

(*
val mappingCount : forall 'k 'v. key_equiv 'k -> multimap 'k 'v -> natural
val any : forall 'k 'v. ('k -> 'v -> bool) -> multimap 'k 'v -> bool 
val all : forall 'k 'v. ('k -> 'v -> bool) -> multimap 'k 'v -> bool 
*)
(*val findLowestKVWithKEquivTo : forall 'k 'v. 
    Ord 'k, Ord 'v, SetType 'k, SetType 'v =>
        'k 
        -> key_equiv 'k 
        -> multimap 'k 'v 
        -> maybe ('k * 'v) 
        -> maybe ('k * 'v)*)
function (sequential,domintros)  findLowestKVWithKEquivTo  :: " 'k Ord_class \<Rightarrow> 'v Ord_class \<Rightarrow> 'k \<Rightarrow>('k \<Rightarrow> 'k \<Rightarrow> bool)\<Rightarrow>('k*'v)set \<Rightarrow>('k*'v)option \<Rightarrow>('k*'v)option "  where 
     " findLowestKVWithKEquivTo dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 subSet maybeBest = (
  if \<not> finite subSet then
    undefined
  else if \<not> well_behaved_lem_ordering (isLess_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v))
    (isLessEqual_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v))
    (isGreater_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v))
    (compare_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v)) then
    undefined
  else
    (case  Lem_set_extra.chooseAndSplit 
  (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k
     dict_Basic_classes_Ord_v) subSet of
        None => (* empty subset *) maybeBest
      | Some(lower, ((chosenK:: 'k), (chosenV :: 'v)), higher) =>
            (* is k equiv to chosen? *)
            if equiv1 k chosenK
            then
                (* is chosen less than our current best? *)
                (let (bestK, bestV) = ((case  maybeBest of
                    None => (chosenK, chosenV)
                    | Some(currentBestK, currentBestV) => 
                        if pairLess 
  dict_Basic_classes_Ord_v dict_Basic_classes_Ord_k (chosenK, chosenV) (currentBestK, currentBestV)
                            then (chosenK, chosenV)
                            else (currentBestK, currentBestV)
                ))
                in
                (* recurse down lower subSet; best is whichever is lower *)
                findLowestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 lower (Some(bestK, bestV)))
            else
                (* k is not equiv to chosen; do we need to look lower or higher? *)
                if (isLess_method   dict_Basic_classes_Ord_k) k chosenK
                then
                    (* k is lower, so look lower for equivs-to-k *)
                    findLowestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 lower maybeBest
                else
                    (* k is higher *)
                    findLowestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 higher maybeBest
    ))" 
by pat_completeness auto


(*val testEquiv : natural -> natural -> bool*)
definition testEquiv  :: " nat \<Rightarrow> nat \<Rightarrow> bool "  where 
     " testEquiv x y = ( if ((x \<ge>( 3 :: nat)) \<and> ((x <( 5 :: nat)) \<and> ((y \<ge>( 3 :: nat)) \<and> (y \<le>( 5 :: nat))))) then True
     else if ((x <( 3 :: nat)) \<and> (y <( 3 :: nat))) then True
     else if ((x >( 5 :: nat)) \<and> (y >( 5 :: nat))) then True
     else False )"


(* Note we can't just use findLowestEquiv with inverted relations, because 
 * chooseAndSplit returns us (lower, chosen, higher) and we need to swap
 * around how we consume that. *)
(*val findHighestKVWithKEquivTo : forall 'k 'v. 
    Ord 'k, Ord 'v, SetType 'k, SetType 'v =>
        'k 
        -> key_equiv 'k 
        -> multimap 'k 'v 
        -> maybe ('k * 'v) 
        -> maybe ('k * 'v)*)
function (sequential,domintros)  findHighestKVWithKEquivTo  :: " 'k Ord_class \<Rightarrow> 'v Ord_class \<Rightarrow> 'k \<Rightarrow>('k \<Rightarrow> 'k \<Rightarrow> bool)\<Rightarrow>('k*'v)set \<Rightarrow>('k*'v)option \<Rightarrow>('k*'v)option "  where 
     " findHighestKVWithKEquivTo dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 subSet maybeBest = (
  if \<not> finite subSet then
    undefined
  else if \<not> well_behaved_lem_ordering (isLess_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v))
    (isLessEqual_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v))
    (isGreater_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v))
    (compare_method (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v)) then
    undefined
  else 
    (case  Lem_set_extra.chooseAndSplit 
  (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k
     dict_Basic_classes_Ord_v) subSet of
        None => (* empty subset *) maybeBest
      | Some(lower, ((chosenK:: 'k), (chosenV :: 'v)), higher) =>
            (* is k equiv to chosen? *)
            if equiv1 k chosenK
            then
                (* is chosen greater than our current best? *)
                (let (bestK, bestV) = ((case  maybeBest of
                    None => (chosenK, chosenV)
                    | Some(currentBestK, currentBestV) => 
                        if pairGreater 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v (chosenK, chosenV) (currentBestK, currentBestV)
                            then (chosenK, chosenV)
                            else (currentBestK, currentBestV)
                ))
                in
                (* recurse down higher-than-chosen subSet; best is whichever is higher *)
                findHighestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 higher (Some(bestK, bestV)))
            else
                (* k is not equiv to chosen; do we need to look lower or higher? 
                 * NOTE: the pairs in the set must be lexicographically ordered! *)
                if (isGreater_method   dict_Basic_classes_Ord_k) k chosenK
                then
                    (* k is higher than chosen, so look higher for equivs-to-k *)
                    findHighestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 higher maybeBest
                else
                    (* k is lower than chosen, so look lower *)
                    findHighestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 lower maybeBest
    ))" 
by pat_completeness auto


(* get the list of all pairs with key equiv to k. *)
(*val lookupBy : forall 'k 'v. 
    Ord 'k, Ord 'v, SetType 'k, SetType 'v =>
        key_equiv 'k -> 'k -> multimap 'k 'v -> list ('k * 'v)*)
definition lookupBy0  :: " 'k Ord_class \<Rightarrow> 'v Ord_class \<Rightarrow>('k \<Rightarrow> 'k \<Rightarrow> bool)\<Rightarrow> 'k \<Rightarrow>('k*'v)set \<Rightarrow>('k*'v)list "  where 
     " lookupBy0 dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v equiv1 k m = ( 
    (* Find the lowest and highest elements equiv to k. 
     * We do this using chooseAndSplit recursively. *)
    (case  findLowestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 m None of
        None => []
        | Some lowestEquiv => 
            (let (highestEquiv :: ('k * 'v)) =                
( 
                (* We can't just invert the relation on the set, because
                 * the whole set is ordered *)(case  findHighestKVWithKEquivTo 
  dict_Basic_classes_Ord_k dict_Basic_classes_Ord_v k equiv1 m None of
                    None => failwith (''impossible: lowest equiv but no highest equiv'')
                    | Some highestEquiv => highestEquiv
                ))
        in
        (* FIXME: split is currently needlessly inefficient on OCaml! *)
        (let (lowerThanLow, highEnough) = (Lem_set.split 
  (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k
     dict_Basic_classes_Ord_v) lowestEquiv m)
        in 
        (let (wanted, tooHigh) = (Lem_set.split 
  (instance_Basic_classes_Ord_tup2_dict dict_Basic_classes_Ord_k
     dict_Basic_classes_Ord_v) highestEquiv highEnough)
        in        
(
        (* NOTE that lowestEquiv is a single element; we want to include 
         * *all those equiv to it*, which may be non-equal. FIXME: use splitMember,
         * although that needs fixing in Lem (plus an optimised OCaml version). *)(list_of_set 
  (set_filter
     (\<lambda> s .  (EQ =
                        (pairCompare
                           (compare_method   dict_Basic_classes_Ord_k)
                           (compare_method   dict_Basic_classes_Ord_v) 
                         s lowestEquiv))) m)) @ (list_of_set wanted)) @ (
            (* don't include the lowest and highest twice, if they're the same *)
            if pairLess 
  dict_Basic_classes_Ord_v dict_Basic_classes_Ord_k lowestEquiv highestEquiv then (list_of_set 
  (set_filter
     (\<lambda> s .  (EQ =
                        (pairCompare
                           (compare_method   dict_Basic_classes_Ord_k)
                           (compare_method   dict_Basic_classes_Ord_v) 
                         s highestEquiv))) m)) else []
        ))))
    ))"



(* To delete all pairs with key equiv to k, can use deleteBy *)

end
