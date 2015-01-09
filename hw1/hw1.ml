(* returns true iff list p contains element q *)
let rec contains p q = 
   match p with 
   | [] -> false
   | hd::tl -> if hd=q then true else (contains tl q)
;;

let contains_test_0 = contains [1;2;3] 1;;
let contains_test_1 = contains [1;2;3] 4;;
let contains_test_2 = contains [] 4;;

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
let rec set_diff_rec this before after other = 
    match after with 
    | [] -> before
    | hd::tl -> before
;;


