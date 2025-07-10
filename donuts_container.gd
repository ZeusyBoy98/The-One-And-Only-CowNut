extends HBoxContainer

@export var donut_scene: PackedScene
@export var max_donuts := 5

func update_donuts(current_health: int):
	for child in get_children():
		child.queue_free()

	for i in range(current_health):
		var donut = donut_scene.instantiate()
		add_child(donut)
