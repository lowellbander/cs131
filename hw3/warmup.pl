len([], 0).
len([_|T], N):- len(T, NT), N is NT+1.

allElemSizeN([], _).
allElemSizeN([H|T],N):- len(H, N), allElemSizeN(T, N).

nxn(N, S):- len(S, N), allElemSizeN(S, N).
