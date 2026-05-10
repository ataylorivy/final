extends Node
var player: CharacterBody2D
var astar_grid: AStarGrid2D
var tilemap: TileMapLayer
var player_info: player_data
var points : int

func go_to_player(enemy_position: Vector2) -> Array[Vector2i]:
	if not player or not astar_grid or not tilemap:
		print("something went wrong") 
		return []
	var start = tilemap.local_to_map(tilemap.to_local(enemy_position))
	var end = tilemap.local_to_map(tilemap.to_local(player.global_position))
	return astar_grid.get_id_path(start, end)

func _ready():
	var path = "user://player_data.tres"
	var base_player = "res://resources/player/player_data.tres"
	if FileAccess.file_exists(path):
		player_info = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		player_info = load(base_player).duplicate(true)
		
func save_player():
	print(player_info.name)
	ResourceSaver.save(player_info, "user://player_data.tres")

func reset():
	var path = "user://player_data.tres"
	var base_player = "res://resources/player/player_data.tres"
	DirAccess.remove_absolute(path)
	player_info = load(base_player).duplicate(true)
	var file = FileAccess.open("user://seen_first_cs.json", FileAccess.WRITE)
	var data = {"seen" : false}
	file.store_string(str(data))
	file.close()
	get_tree().change_scene_to_file.call_deferred("res://scenes/title_screen.tscn")
	
func win():
	get_tree().change_scene_to_file.call_deferred("res://win_cutscene.tscn")
	
	
