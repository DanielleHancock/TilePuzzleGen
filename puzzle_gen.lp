#const width=5.
#const height=5.
#const min_solve_length = width.
#const max_solve_length = (width*height)/2.

start(1,1).
finish(width,height).

width_dim(1..width).
height_dim(1..height).
step(0,-1; 0,1; 1,0; -1,0).
integer(0..width*height).

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

reachable_in(X,Y,0,no_scent,X,Y) :- start(X,Y), pink(X,Y).
reachable_in(X,Y,0,orange_scent,X,Y) :- start(X,Y), orange(X,Y).

% Player can move to any adjacent pink tile (Player's scent is unchanged)
reachable_in(NX, NY, T+1, S, X, Y) :-
	reachable_in(X,Y,T,S,prevX,prevY),
	T < max_solve_length,
	scent(S),
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	pink(NX,NY),
	(NX, NY) != (prevX, prevY).

% Player can move to an adjacent blue tile if its not electrified and player does not have orange scent
reachable_in(NX, NY, T+1, no_scent, X, Y) :-
	reachable_in(X,Y,T,no_scent,prevX,prevY),
	T < max_solve_length,
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	not_electric_blue(NX,NY),
	(NX, NY) != (prevX, prevY).

% Player can move to an adjacent orange tile, and will receive orange scent
reachable_in(NX, NY, T+1, orange_scent, X, Y) :-
	reachable_in(X,Y,T,S,prevX,prevY),
	T < max_solve_length,
	step(DX, DY),
	NX = X + DX,
	NY = Y + DY,	
	orange(NX,NY),
	(NX, NY) != (prevX, prevY).

% Player can slide across a purple tile to the next tile
% Sliding across purple tile erases player scent
slidable_dist(2..width).
reachable_in(NX, NY, T+N, no_scent, X, Y) :-
	reachable_in(X,Y,T,S,prevX,prevY),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	pink(NX,NY),
	(NX, NY) != (prevX, prevY).

reachable_in(NX, NY, T+N, no_scent, x, Y) :-
	reachable_in(X,Y,T,S,prevX,prevY),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	not_electric_blue(NX,NY),
	(NX, NY) != (prevX, prevY).


reachable_in(NX, NY, T+N, orange_scent, X, Y) :-
	reachable_in(X,Y,T,S,prevX,prevY),
	T < max_solve_length,
	step(DX, DY),
	slidable_dist(N),
	NX = X + DX*N,
	NY = Y + DY*N,
	at(X+DX..X+DX*(N-1), Y+DY..Y+DY*(N-1), purple),
	orange(NX,NY),
	(NX, NY) != (prevX, prevY).


finish_in(T) :- finish(X,Y), reachable_in(X, Y, T, _, _, _).

% Find the length of the shortest solution
shortest_solution(T) : finish_in(T).
:- shortest_solution(T1), shortest_solution(T2), T1!=T2.
#minimize{T : shortest_solution(T)}.

% There must be a solution with length < max_solve_length.
finish_in(max_solve_length).

% There cannot exist a solution with length < min_solve_length.
:- finish_in(T), T < min_solve_length.

% Count how many tiles are of each type.
1 {num_tiles(Tile, Num)} 1 
	:- tile_type(Tile), Num = #count{X,Y : at(X,Y,Tile)}.

% A single tile type cannot have two different values for num_tiles
:- num_tiles(Tile, Num1), num_tiles(Tile, Num2), Num1!=Num2.

% States that the number of tiles of type Tile is at least Num
at_least(Tile, Min) :- num_tiles(Tile, Num), Num >= Min, integer(Min).
:- at_least(Tile,Min), num_tiles(Tile,Num), Num<Min.

#show start/2.
#show finish/2.
#show num_tiles/2.
#show at/3.
#show shortest_solution/1.