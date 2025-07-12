extends CanvasLayer
var save_nodes = []

func _ready():
	save_nodes = get_tree().get_nodes_in_group("Persist")

func _on_quit_pressed() -> void:
	self.queue_free()
	get_tree().change_scene_to_file("res://UI/start.tscn")

func _on_resume_pressed() -> void:
	var root = get_tree().get_root()
	root.remove_child(self)
	root.add_child(Global.level_instance)
