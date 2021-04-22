from clyngor import ASP, solve

answers = solve('puzzle_gen.lp', nb_model=1)

for x in answers:
	print(x)