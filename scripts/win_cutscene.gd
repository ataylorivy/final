extends Control


func _on_restart_pressed() -> void:
	global.reset()
	
	


func _on_return_pressed() -> void:
	global.points = 0
	get_tree().change_scene_to_file.call_deferred("res://scenes/main.tscn")
