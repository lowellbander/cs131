% test cases

test_1(1, []).
test_2(2, []).

% implementation of kenken/3

kenken(N, [], L):-  length(L, N).
                    %distinct_null(N, L),
                    %trans(L, LTrans),
                    %distinct_null(N, LTrans),
                    %statistics.

% fd_domain(Vars, Lower, Upper) constraints each element X of Vars to take a 
% value in Lower..Upper.

distinct_null(_, []).
%distinct_null(N, [Lx|Ly]):- length(Lx, N),
                            


