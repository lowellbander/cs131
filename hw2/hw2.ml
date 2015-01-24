(* when called with two arguments, 
 * returns the production function for a rule_list *)
let rec prod_func rule_list alternatives the_nonterm =
    match rule_list with
    | [] -> alternatives
    | head::tail -> match head with 
                        (symb, rhs)  ->
                        if symb == the_nonterm
                        then prod_func tail (alternatives @ [rhs]) the_nonterm
                        else prod_func tail alternatives the_nonterm
;;

(* given a hw1-style grammar, return a hw2-style grammar *)
let convert_grammar gram1 = 
    match gram1 with
    (start_symb, rule_list) -> (start_symb, prod_func rule_list [])
                                (* rule_list : list of rules in gram1
                                 * [] : the acceptor function (?)*)
;;

(* returns a matcher for the grammar gram *)
let parse_prefix gram =
    gram
;;

