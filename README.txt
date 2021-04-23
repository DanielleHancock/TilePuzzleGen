clingo -n 1 --rand-freq=1 --seed=%random% puzzle_gen.lp

Pink tiles are always passable.
Red tiles are impassable.
Orange tiles are passable and give you orange scent.
You slide across purple tiles in the direction you are facing. Purple tiles also remove scent.
Yellow tiles are electric (impassable).
Blue tiles are water:
	Blue tiles are impassable if they are adjacent to a yellow tile. (Water is electrified).
	Blue tiles are impassable if you smell like oranges. (Piranhas will eat you!).
	Otherwise, blue tiles are passable.
