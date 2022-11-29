extends Node2D

func check_level():
	var count = 0
	for c in get_children():
		if not c.dying:
			count += 1
	if count == 0:
		Global.next_level()

func weaken():
	for c in get_children():
		c.fragile()

func restore():
	for c in get_children():
		c.strong()

