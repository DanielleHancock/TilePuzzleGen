#const width=10.
#const height=5.
#const min_solve_length = width.
#const max_solve_length = (width+height)*2.

start(1,1).
finish(width,height).

width_dim(1..width).
height_dim(1..height).
step(0,-1; 0,1; 1,0; -1,0).

tile_type(red;pink;yellow;blue;purple;orange).
not_yellow(red;pink;blue;purple;orange).
scent(no_scent;orange_scent).

1 {at(X,Y,T) : tile_type(T)} 1
  :- width_dim(X), height_dim(Y).

pink(X,Y) :- at(X,Y,pink).
orange(X,Y) :- at(X,Y,orange).

% blue tile is electric if it adjacent to a yellow tile
not_electric_blue(X,Y) :- at(X,Y,blue), 
	at(X,Y+1, not_yellow), 
	at (X,Y-1, not_yellow), 
	at(X+1,Y, not_yellow), 
	at(X-1,Y, not_yellow).

reachable_in(X,Y,0,no_scent) :- start(X,Y), pink(X,Y).
reachable_in(X,Y,0,orange_scent) :- start(X,Y), orange(X,Y).

% Player can move to any adjacent pink tile (Player's scent is unchanged)
reachable_in(NX, NY, T+1, S) :-
	reachable_in(X,Y,T,S),
	T < max_solve_length,
	scent(S),
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	pink(NX,NY).

% Player can move to an adjacent blue tile if its not electrified and player does not have orange scent
reachable_in(NX, NY, T+1, no_scent) :-
	reachable_in(X,Y,T,no_scent),
	T < max_solve_length,
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	not_electric_blue(NX,NY).

% Player can move to an adjacent orange tile, and will receive orange scent
reachable_in(NX, NY, T+1, orange_scent) :-
	reachable_in(X,Y,T,S),
	T < max_solve_length,
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	orange(NX,NY).

% Player can slide across a purple tile to the next tile
% Sliding across purple tile erases player scent
slidable_dist(2..width).
reachable_in(NX, NY, T+N, no_scent) :-
	reachable_in(X,Y,T,S),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	pink(NX,NY).

reachable_in(NX, NY, T+N, no_scent) :-
	reachable_in(X,Y,T,S),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	not_electric_blue(NX,NY).


reachable_in(NX, NY, T+N, orange_scent) :-
	reachable_in(X,Y,T,S),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	orange(NX,NY).


finish_in(T) :- finish(X,Y), reachable_in(X, Y, T, S), scent(S).

% There must be a solution with length < max_solve_length.
finish_in(max_solve_length).

% There cannot exist a solution with length < min_solve_length.
:- finish_in(T), T < min_solve_length.


#show at/3.