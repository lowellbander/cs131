% BEGIN testcases

test_0(2,[]).
 
kenken_testcase(
    6, 
    [
        +(11, [1-1, 2-1]),
        /(2, 1-2, 1-3),
        *(20, [1-4, 2-4]),
        *(6, [1-5, 1-6, 2-6, 3-6]),
        -(3, 2-2, 2-3),
        /(3, 2-5, 3-5),
        *(240, [3-1, 3-2, 4-1, 4-2]),
        *(6, [3-3, 3-4]),
        *(6, [4-3, 5-3]),
        +(7, [4-4, 5-4, 5-5]),
        *(30, [4-5, 4-6]),
        *(6, [5-1, 5-2]),
        +(9, [5-6, 6-6]),
        +(8, [6-1, 6-2, 6-3]),
        /(2, 6-4, 6-5)
    ]
).
% END testcases

rangesFrom1to(N, L):-   fd_domain(L, 1, N).

% isOfLength/2 - checks that list L has length N
isOfLength(N, L):- length(L, N).

% nth(I, T, E) - retrieve the Ith element of T and place it in E

% E = Matrix[I][J]
get(Matrix, I-J, E):-   nth(I, Matrix, Row), 
                        nth(J, Row, E).

transpose([], []).
transpose([F|Fs], T):-  transpose(F, [F|Fs], T).
 
transpose([], _, []).
transpose([_|R], M, [T|Ts]):-   lists_firsts_rests(M, T, Ms), 
                                transpose(R, Ms, Ts).
 
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]):-
                                    lists_firsts_rests(Rest, Fs, Oss).
 
% fdomain kenken implementation
 
product(X, Y, Product):- Product is X * Y.
 
reduce(_, [], FinalResult, FinalResult).
reduce(Function, [Head|Tail], OldResult, FinalResult):-
                        call(Function, Head, OldResult, NewResult),
                        reduce(Function, Tail, NewResult, FinalResult).

reduce_reduce_sum(T, [], Result, Result).
reduce_reduce_sum(T, [Head|Tail], OldSum, Result):-   get(T, Head, E), 
                                        Newreduce_sum #= OldSum + E, 
                                        reduce_reduce_sum(T, Tail, NewSum, Result).
 
reduce_product(T, [], Result, Result).
reduce_product(T, [Head|Tail], OldProduct, Result):- 
                                    get(T, Head, E), 
                                    NewProduct #= OldProduct * E, 
                                    reduce_product(T, Tail, NewProduct, Result).
getValues(_, [], []).
getValues(T, [Head|Tail], [Value|L]):-  get(T, Head, Value),
                                        getValues(T, Tail, L).
 
test(T, +(Result, List)):-  getValues(T, List, Z), 
                            reduce_reduce_sum(T, List, 0, Result).

test(T, *(Result, List)):-  getValues(T, List, Z), 
                            % reduce(product, Z, 1, Result).
                            reduce_product(T, List, 1, Result).

test(T, /(Result, CoordA, CoordB)):-    get(T, CoordA, A), 
                                        get(T, CoordB, B), 
                                        (Result #= A // B; Result #= B // A).

test(T, -(Result, CoordA, CoordB)):-    get(T, CoordA, A), 
                                        get(T, CoordB, B), 
                                        (Result #= A - B ; Result #= B - A).
 
kenken(N, C, T):-   length(T, N), 
                    maplist(isOfLength(N), T),      % T isOfLength N
                    maplist(rangesFrom1to(N), T),   % every row in T is 1 ... N
                    maplist(fd_all_different, T),   % and only has unique elements
                    transpose(T, X_t),              % transpose the matrix
                    maplist(fd_all_different, X_t), % and check for uniqueness
                    maplist(test(T), C),            % check each constraint
                    maplist(fd_labeling, T),        %
                    true.
 
% plain kenken implementation
 
range(N, L):-   findall(X, between(1, N, X), L).
 
check_doplain([], _).
check_doplain([Head|T], R):-   member(Head, R), 
                            check_doplain(T, R).
 
set(L):- setof(X, member(X, L), S), 
            length(L, N), 
            length(S, N).
 
check_dom_plain([], _).
check_dom_plain([Head|T], R):- check_doplain(Head, R), 
                            set(Head), 
                            check_dom_plain(T, R).
 

reduce_reduce_sum_plain(T, [], Result, Result).
reduce_reduce_sum_plain(T, [Head|Tail], S, Result):-    get(T, Head, X), 
                                    reduce_sum is S + X, 
                                    reduce_reduce_sum_plain(T, Tail, Sum, Result).
 
reduce_product_plain(T, [], Result, Result).
reduce_product_plain(T, [Head|Tail], P, Result):- get(T, Head, X), 
                                            Prod is P * X, 
                                            reduce_product_plain(T, Tail, Prod, Result).
 
test_plain(T, +(Result, List)):-    reduce_reduce_sum_plain(T, List, 0, Result).
test_plain(T, *(Result, List)):-    reduce_product_plain(T, List, 1, Result).
test_plain(T, /(Result, CoordA, CoordB)):-  get(T, CoordA, A), 
                                            get(T, CoordB, B), 
                                            (Result is A // B ; Result is B // A).

test_plain(T, -(Result, CoordA, CoordB)):-  get(T, CoordA, A), 
                                            get(T, CoordB, B), 
                                            (Result is A - B ; Result is B - A).
 
plain_kenken(N, C, T):- length(T, N), 
                        range(N, R), 
                        maplist(isOfLength(N), T), 
                        check_dom_plain(T, R), 
                        transpose(T, X_t), 
                        maplist(set, X_t), 
                        maplist(test_plain(T), C), 
                        statistics.
 
