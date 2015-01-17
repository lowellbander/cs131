let contains_test_0 = contains [1;2;3] 1;;
let contains_test_1 = not (contains [1;2;3] 4);;
let contains_test_2 = not (contains [] 4);;

let subset_test_0 = subset [] [];;
let subset_test_1 = subset [] [1];;
let subset_test_2 = subset [] [1;2];;
let subset_test_3 = not (subset [1] []);;
let subset_test_4 = subset [1;2;3] [1;2;3];;
let subset_test_5 = not(subset [1;2;3] [1;2;4]);;

let equal_sets_test_0 = equal_sets [1;2;3] [1;2;3];;
let equal_sets_test_1 = equal_sets [1;3;2] [1;2;3];;
let equal_sets_test_2 = equal_sets [] [];;
let equal_sets_test_3 = not(equal_sets [1] []);;
let equal_sets_test_3 = not(equal_sets [1] [2]);;
let equal_sets_test_4 = equal_sets [3;1;3] [1;3];;

let unique_test_0 = unique [1;2;3];;
let unique_test_1 = unique [2;2];;
let unique_test_2 = unique [];;

let proper_subset_test0 = proper_subset [] [1;2;3]
let proper_subset_test1 = proper_subset [3;1;3] [1;2;3]
let proper_subset_test2 = not (proper_subset [3] [3;3])

let set_diff_test_0 = (set_diff [] []) = [];;
let set_diff_test_1 = (set_diff [1] []) = [1];;
let set_diff_test_2 = (set_diff [1] [1]) = [];;
let set_diff_test_3 = (set_diff [1] [2]) = [1];;
let set_diff_test_4 = equal_sets (set_diff [1;2;3] [2]) [1;3];;
let set_diff_test0 = equal_sets (set_diff [1;3] [1;4;3;1]) []
let set_diff_test1 = equal_sets (set_diff [4;3;1;1;3] [1;3]) [4]
let set_diff_test2 = equal_sets (set_diff [4;3;1] []) [1;3;4]
let set_diff_test3 = equal_sets (set_diff [] [4;3;1]) []

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

let eval_p_times_test0 = eval_p_times (fun x -> x + x) 3 2;;

(* Every point is a periodic point for p=0 *)
let computed_periodic_point_test0 =
    computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1;;
let computed_periodic_point_test1 =
    computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.;;

type giant_nonterminals =
      | Conversation | Sentence | Grunt | Snore | Shout | Quiet

let giant_rules = 
    [Snore, [T"ZZZ"];
    Quiet, [];
    Grunt, [T"khrgh"];
    Shout, [T"aooogah!"];
    Sentence, [N Quiet];
    Sentence, [N Grunt];
    Sentence, [N Shout];
    Conversation, [N Snore];
    Conversation, [N Sentence; T","; N Conversation]];;

let giant_grammar = Conversation, giant_rules;;

let remove_blind_alleys_test0 = 
    remove_blind_alleys [Conversation] (snd giant_grammar);;

let sm_gram = Conversation, [(Conversation,[T"blargh"])];;
let med_gram = Conversation, [(Conversation,[T"blargh"; N Sentence])];;
let lg_gram = Conversation, [(Conversation,[T"blargh"; N Sentence])];;

let make_whitelist_test0 =  make_whitelist (snd giant_grammar, []);;
let make_whitelist_test1 =  make_whitelist (List.tl (snd giant_grammar), []);;

(* computed_fixed_point (equal_sets) (make_whitelist) (rules, []);; *)

(*let giant_test0 = filter_blind_alleys giant_grammar = giant_grammar;;*)

