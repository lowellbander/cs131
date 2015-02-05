% test cases
% fd_set_vector_max(255), test_i(N,C), kenken(N,C,T).

test_1(1, []).
test_2(2, []).

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

kenken(N, [], T):-  length(T, N),
                    distinct_null(N, T), % every row is distinct (?)
                    %transpose(T, T_transposed),
                    %distinct_null(N, T_transposed),
                    %statistics.
                    true.

% fd_domain/3 - http://www.gprolog.org/manual/gprolog.html#sec307
% fd_all_different/1 - http://www.gprolog.org/manual/gprolog.html#sec325
% fd_labeling/1 - http://www.gprolog.org/manual/gprolog.html#fd-labeling%2F2

% base case
distinct_null(_, []).
% recursive case
distinct_null(N, [Lx|Ly]):- length(Lx, N),          % is of length N
                            fd_domain(Lx, 1, N),    % only contains 1 ... N
                            fd_all_different(Lx),   % all elements are different
                            fd_labeling(Lx),        % assigns vals to all elements
                            distinct_null(N, Ly).
                            
                            


