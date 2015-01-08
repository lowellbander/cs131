(* returns true iff list p contains element q *)
let rec contains p q = 
   match p with 
   | [] -> false
   | hd::tl -> if hd=q then true else (contains tl q)
;;

let contains_test_0 = contains [1;2;3] 1;;
let contains_test_1 = contains [1;2;3] 4;;
let contains_test_2 = contains [] 4;;

(*returns true iff a subset of b*)
let rec subset a b = 
    match a with
    | [] -> true
    | hd::tl -> if (contains b hd ) then (subset tl b) else false
;;

let subset_test_0 = subset [] [];;
let subset_test_1 = subset [] [1];;
let subset_test_2 = subset [] [1;2];;
let subset_test_3 = subset [1] [];;
let subset_test_4 = subset [1;2;3] [1;2;3];;
let subset_test_5 = subset [1;2;3] [1;2;4];;

