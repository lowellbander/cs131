(* returns true iff list p contains element q *)
let rec contains p q = 
   match p with 
   | [] -> false
   | hd::tl -> if hd=q then true else (contains tl q)
;;

let contains_test_0 = contains [1;2;3] 1;;
let contains_test_1 = not (contains [1;2;3] 4);;
let contains_test_2 = not (contains [] 4);;

(* returns true iff a subset of b *)
let rec subset a b = 
    match a with
    | [] -> true
    | hd::tl -> if (contains b hd ) then (subset tl b) else false
;;

let subset_test_0 = subset [] [];;
let subset_test_1 = subset [] [1];;
let subset_test_2 = subset [] [1;2];;
let subset_test_3 = not (subset [1] []);;
let subset_test_4 = subset [1;2;3] [1;2;3];;
let subset_test_5 = not(subset [1;2;3] [1;2;4]);;

let equal_sets a b =
    if (subset a b) then (subset b a) else false
;;

let equal_sets_test_0 = equal_sets [1;2;3] [1;2;3];;
let equal_sets_test_1 = equal_sets [1;3;2] [1;2;3];;
let equal_sets_test_2 = equal_sets [] [];;
let equal_sets_test_3 = not(equal_sets [1] []);;
let equal_sets_test_3 = not(equal_sets [1] [2]);;
let equal_sets_test_4 = equal_sets [3;1;3] [1;3];;

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

let unique_test_0 = unique [1;2;3];;
let unique_test_1 = unique [2;2];;
let unique_test_2 = unique [];;

let proper_subset a b = 
    if (unique a = unique b) then false else (subset a b)
;;

let proper_subset_test0 = proper_subset [] [1;2;3]
let proper_subset_test1 = proper_subset [3;1;3] [1;2;3]
let proper_subset_test2 = not (proper_subset [3] [3;3])

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

let set_diff_test_0 = (set_diff [] []) = [];;
let set_diff_test_1 = (set_diff [1] []) = [1];;
let set_diff_test_2 = (set_diff [1] [1]) = [];;
let set_diff_test_3 = (set_diff [1] [2]) = [1];;
let set_diff_test_4 = equal_sets (set_diff [1;2;3] [2]) [1;3];;
let set_diff_test0 = equal_sets (set_diff [1;3] [1;4;3;1]) []
let set_diff_test1 = equal_sets (set_diff [4;3;1;1;3] [1;3]) [4]
let set_diff_test2 = equal_sets (set_diff [4;3;1] []) [1;3;4]
let set_diff_test3 = equal_sets (set_diff [] [4;3;1]) []

let rec computed_fixed_point eq f x = 
    if (eq (f x) x) then x else (computed_fixed_point eq f (f x))
;;

let computed_fixed_point_test0 =
    computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0;;
let computed_fixed_point_test1 =
    computed_fixed_point (=) (fun x -> x *. 2.) 1. = infinity;;
let computed_fixed_point_test2 =
    computed_fixed_point (=) sqrt 10. = 1.;;
let computed_fixed_point_test3 =
      ((computed_fixed_point (fun x y -> abs_float (x -. y) < 1.)
                             (fun x -> x /. 2.)
                             10.)
      = 1.25);;

let rec eval_p_times f x p = 
    if (0 < p)  then (eval_p_times f (f x) (p - 1))
                else x
;;

let eval_p_times_test0 = eval_p_times (fun x -> x + x) 3 2;;

let rec computed_periodic_point eq f p x =
    if eq x (eval_p_times f x p) then x
        else (computed_periodic_point eq f p (f x))
;;

(* Every point is a periodic point for p=0 *)
let computed_periodic_point_test0 =
    computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1;;
let computed_periodic_point_test1 =
    computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.;;

(* END WARMUP *)

type giant_nonterminals =
      | Conversation | Sentence | Grunt | Snore | Shout | Quiet

let giant_grammar =
    Conversation,
    [Snore, [T"ZZZ"];
    Quiet, [];
    Grunt, [T"khrgh"];
    Shout, [T"aooogah!"];
    Sentence, [N Quiet];
    Sentence, [N Grunt];
    Sentence, [N Shout];
    Conversation, [N Snore];
    Conversation, [N Sentence; T","; N Conversation]]

type ('nonterminal, 'terminal) symbol =
    | N of 'nonterminal
    | T of 'terminal
;;

(* probably should be the opposite *)
let rec remove_blind_alleys_rec before rule after whitelist =
    match after with 
    | [] -> if (contains whitelist (fst rule))
            then rule::before
            else before
    | hd::tl -> if (contains whitelist (fst rule))
                then (remove_blind_alleys_rec (rule::before) hd tl whitelist)
                else (remove_blind_alleys_rec before hd tl whitelist)
;;

let remove_blind_alleys whitelist rules =
    match rules with
    | [] -> []
    | hd::tl -> remove_blind_alleys_rec [] hd tl whitelist
;;

let remove_blind_alleys_test0 = 
    remove_blind_alleys [Snore] (snd giant_grammar);;

(* TODO *)
let filter_blind_alleys g =
    match g with 
    (starting_symbol, rules) -> rules
;;

let giant_test0 =
    filter_blind_alleys giant_grammar = giant_grammar;;

filter_blind_alleys giant_grammar 

