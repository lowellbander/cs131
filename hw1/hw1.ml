(* returns true iff list l contains element e *)
let rec contains l e = 
   match l with 
   | [] -> false
   | hd::tl -> if hd = e then true else (contains tl e)
;;

(* returns true iff a subset of b *)
let rec subset a b = 
    match a with
    | [] -> true
    | hd::tl -> if (contains b hd ) then (subset tl b) else false
;;

let equal_sets a b =
    if (subset a b) then (subset b a) else false
;;

(* initially, called as:
    * unique 'a [] 'a list
 * returns unique elements in the third argument ('a list)
 * *)
let rec unique_rec before this after = 
    match after with 
    | [] -> this::before
    | hd::tl -> if (contains after this) 
                then (unique_rec before hd tl) 
                else (unique_rec (this::before) hd tl)
;;

(* helper for unique_rec *)
let unique lst =
    match lst with
    | hd::tl -> unique_rec [] hd tl
    | [] -> []
;;

let proper_subset a b = 
    if (unique a = unique b) then false else (subset a b)
;;

(* returns the set difference of a - b *)
let rec set_diff_rec before this after other = 
    match after with 
    | [] -> if (contains other this)
            then before
            else this::before
    | hd::tl -> if (contains other this)
                then (set_diff_rec before hd tl other)
                else (set_diff_rec (this::before) hd tl other)
;;

(* helper for set_diff_rec *)
let set_diff a b = 
    match a with
    | [] -> []
    | hd::tl -> set_diff_rec [] hd tl b
;;

let rec computed_fixed_point eq f x = 
    if (eq (f x) x) then x else (computed_fixed_point eq f (f x))
;;

let rec eval_p_times f x p = 
    if (0 < p)  then (eval_p_times f (f x) (p - 1))
                else x
;;

let rec computed_periodic_point eq f p x =
    if eq x (eval_p_times f x p) then x
        else (computed_periodic_point eq f p (f x))
;;

type ('nonterminal, 'terminal) symbol =
    | N of 'nonterminal
    | T of 'terminal
;;

(* given a whitelist, remove all rules where LHS not in whitelist *)
let rec remove_blind_alleys_rec before rule after whitelist =
    match after with 
    | [] -> if (contains whitelist (fst rule))
            then rule::before
            else before
    | hd::tl -> if (contains whitelist (fst rule))
                then (remove_blind_alleys_rec (rule::before) hd tl whitelist)
                else (remove_blind_alleys_rec before hd tl whitelist)
;;

(* helper function for remove_blind_alleys_rec *)
let remove_blind_alleys whitelist rules =
    match rules with
    | [] -> []
    | hd::tl -> List.rev(remove_blind_alleys_rec [] hd tl whitelist)
;;

let is_terminal s = 
    match s with
    | T s -> true
    | _ -> false
;;

(* all elements in rhs are either in the whitelist or are terminal *)
let rec is_reachable rhs whitelist =
    match rhs with
    | [] -> true
    | hd::tl -> if contains whitelist hd || is_terminal hd
                then is_reachable tl whitelist
                else false
;;

(* create a list of symbols that either directly or indirectly map 
 * to a terminal character*)
let rec make_whitelist (rules,whitelist) = 
    match rules with
    | hd::tl -> let symb = N (fst hd) in
                if is_reachable (snd hd) whitelist
                then make_whitelist (tl, (symb::whitelist))
                else make_whitelist (tl, whitelist)
    | _ -> whitelist
;;

let rec computed_fixed_point_wl (rules, whitelist) = 
    if equal_sets whitelist (make_whitelist (rules, whitelist))
    then whitelist
    else computed_fixed_point_wl (rules, (make_whitelist (rules, whitelist)))
;;

(* TODO *)
(*
let filter_blind_alleys g =
    match g with
    | (start, rules) -> 
            computed_fixed_point (equal_sets) (make_whitelist) (rules, [])
;;
 *)

