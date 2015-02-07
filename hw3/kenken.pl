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

% product(X, Y, Product):- Product is X * Y.
% 
% reduce(_, [], FinalResult, FinalResult).
% reduce(Function, [Head|Tail], OldResult, FinalResult):-
%                         call(Function, Head, OldResult, NewResult),
%                         reduce(Function, Tail, NewResult, FinalResult).

% given a list, of coordinates, return a list of values at those coords
% // does this preserve order? //
% getValues(_, [], _).
% getValues(T, [Head|Tail], L):-  get(T, Head, Value),
%                                 append([Value], L, NewL),
%                                 getValues(T, Tail, NewL).

test(T, +(Result, List)):- sum(T, List, 0, Result).
sum(T, [], Result, Result).
sum(T, [Head|Tail], OldSum, Result):-   get(T, Head, E), 
                                        NewSum #= OldSum + E, 
                                        sum(T, Tail, NewSum, Result).
 
test(T, *(Result, List)):- mult_list(T, List, 1, Result).
mult_list(T, [], Result, Result).
mult_list(T, [Head|Tail], OldProduct, Result):- get(T, Head, E), 
                                                NewProuct #= OldProduct * E, 
                                                mult_list(T, L, NewProuct, Result).
 
test(T, /(Result, A, B)):-  get(T, A, X), 
                            get(T, B, Y), 
                            (X * Result #= Y ; Y * Result #= X).

test(T, -(Result, A, B)):-  get(T, A, X), 
                            get(T, B, Y), 
                            (Result #= X - Y ; Result #= Y - X).
 
kenken(N, C, T):-   length(T, N), 
                    maplist(isOfLength(N), T),      % T isOfLength N
                    maplist(rangesFrom1to(N), T),   % every row in T is 1 ... N
                    maplist(fd_all_different, T),   % and only has unique elements
                    transpose(T, X_t),              % transpose the matrix
                    maplist(fd_all_different, X_t), % and check for uniqueness
                    maplist(test(T), C),            % check each constraint
                    maplist(fd_labeling, T),        %
                    % statistics.
                    true.
 
% plain kenken implementation
 
range(N, L):-   findall(X, between(1, N, X), L).
 
check_doplain([], _).
check_doplain([H|T], R):-   member(H, R), 
                            check_doplain(T, R).
 
is_set(L):- setof(X, member(X, L), S), 
            length(L, N), 
            length(S, N).
 
check_dom_plain([], _).
check_dom_plain([H|T], R):- check_doplain(H, R), 
                            is_set(H), 
                            check_dom_plain(T, R).
 

sum_plain(T, [], Result, Result).
sum_plain(T, [H|L], S, Result):-  get(T, H, X), 
                                    Sum is S + X, 
                                    sum_plain(T, L, Sum, Result).
 
mult_list_plain(T, [], Result, Result).
mult_list_plain(T, [H|L], P, Result):- get(T, H, X), 
                                    Prod is P * X, 
                                    mult_list_plain(T, L, Prod, Result).
 
test_plain(T, +(Result, List)):-   sum_plain(T, List, 0, Result).
test_plain(T, *(Result, List)):-   mult_list_plain(T, List, 1, Result).
test_plain(T, /(Result, A, B)):-   get(T, A, X), 
                                get(T, B, Y), 
                                (Result is X // Y ; Result is Y // X).

test_plain(T, -(Result, A, B)):-   get(T, A, X), 
                                get(T, B, Y), 
                                (Result is X - Y ; Result is Y - X).
 
plain_kenken(N, C, T):- length(T, N), 
                        range(N, R), 
                        maplist(isOfLength(N), T), 
                        check_dom_plain(T, R), 
                        transpose(T, X_t), 
                        maplist(is_set, X_t), 
                        maplist(test_plain(T), C), 
                        statistics.
 
