#const width=5.
#const height=5.
#const min_solve_length = 10.
#const max_solve_length = 25.

dim(1..width).
tile_type(red;pink;yellow;blue;purple).

1 {at(X,Y,T) : tile_type(T)} 1
  :- dim(X), dim(Y).

% pink tiles are always passable
passable_tile(pink).
passable(X,Y) :- at(X,Y,T), passable_tile(T).

% blue tiles are passable, unless adjacent to a yellow tile
passable(X,Y) :- at(X,Y,blue), 
	not at(X,Y+1, yellow), 
	not at (X,Y-1, yellow), 
	not at(X+1,Y,yellow), 
	not at(X-1,Y, yellow).

start(1,1).
finish(width,width).

step(0,-1; 0,1; 1,0; -1,0).

reachable_in(X,Y,0) :- start(X,Y), passable(X,Y).
reachable(X,Y) :- start(X,Y), passable(X,Y).

reachable_in(NX, NY, T+1) :-
	reachable_in(X,Y,T),
	T < max_solve_length,
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	passable(NX,NY).

% player can slide across a purple tile to the next tile
slidable_dist(2..width).
reachable_in(NX, NY, T+N) :-
	reachable_in(X,Y,T),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	passable(NX,NY).


finish_in(T) :- finish(X,Y), reachable_in(X, Y, T).

% There must be a solution with length < max_solve_length.
finish_in(max_solve_length).

% There cannot exist a solution with length < min_solve_length.
:- finish_in(T), T < min_solve_length.


#show at/3.