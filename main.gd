extends Node


func _ready():
	var player = $Player
	var ui = $CanvasLayer/DonutsContainer

	player.health_changed.connect(ui.update_donuts)
	ui.update_donuts(player.current_health)

func _process(delta: float) -> void:
	pass
