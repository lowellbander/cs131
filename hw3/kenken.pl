% test cases
% fd_set_vector_max(255), test_i(N,C), kenken(N,C,T).

test_1(1, []).
test_2(2, []).
test_2a(2, [+(2,[1-1,2-1])]).
test_3(3, []).

% implementation taken from the SWI-PROLOG clpfd library, modified.
% https://github.com/SWI-Prolog/swipl/blob/master/library/clp/clpfd.pl

% transpose/2
transpose([],[]).
transpose([F|Fs], Ts):- transpose(F, [F|Fs], Ts).

% transpose/3
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-  lists_firsts_rests(Ms, Ts, Ms1),
                                    transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
                                    lists_firsts_rests(Rest, Fs, Oss).

% implementation of kenken/3

% T is the solution to the NxN kenken with constraint C.
% It is represented as a list of rows.

% when there are no constraints
kenken(N, [], T):-  length(T, N),
                    distinct_null(N, T), % every row is distinct (?)
                    transpose(T, T_t),
                    distinct_null(N, T_t),
                    %statistics.
                    true.

% when there are constraints
kenken(N, C, T):-   % length(C, C_len),   % are this and the following line neccesary?
                    % C_len #>= 1,        %there must be at least one constraint
                    length(T, N),
                    distinct(N, T),
                    transpose(T, T_t),
                    distinct(N, T_t),
                    run_tests(N, C, T),
                    %statistics
                    true.

run_tests(_, [], _).
run_tests(N, [Test|C], T):- test(Test, T, N),
                            run_tests(N, C, T).

test(+(A, B), L, N):- sum(A, B, 0, L, N).

% fd_domain/3 - http://www.gprolog.org/manual/gprolog.html#sec307
% fd_all_different/1 - http://www.gprolog.org/manual/gprolog.html#sec325
% fd_labeling/1 - http://www.gprolog.org/manual/gprolog.html#fd-labeling%2F2

distinct_null(_, []).
distinct_null(N, [Head|Tail]):- length(Head, N),          % Head is of length N
                                fd_domain(Head, 1, N),    % Head only contains 1 ... N
                                fd_all_different(Head),   % all elements are different
                                fd_labeling(Head),        % assigns vals to all elements
                                distinct_null(N, Tail).
                            
distinct(_, []).
distinct(N, [Head|Tail]):-  length(Head, N),
                            fd_all_different(Head),
                            distinct(N, Tail).
