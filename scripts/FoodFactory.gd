extends Node

func gen_food(index):
	return get_child(index).duplicate()