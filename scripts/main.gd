extends Node2D

var battle_tscn = preload("res://scenes/battle.tscn")


func _ready() -> void:
	global.tilemap = $Ground
	#global.room = 0 
	#$Player.position=$Spawnpoint.position
	var astar_grid = AStarGrid2D.new()
	var used_rect = $Ground.get_used_rect().merge($Wall.get_used_rect())
	astar_grid.region = used_rect
	astar_grid.cell_size = $Ground.tile_set.tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER #no diagonal, does as it says
	astar_grid.update()
	for cell in $Wall.get_used_cells():
		astar_grid.set_point_solid(cell, true) #alarms the enemy to not go here 
	global.astar_grid = astar_grid 
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.start_encounter.connect(_on_enemy_start_encounter)
	$main_theme.play()

func _on_enemy_start_encounter(enemy, data: enemy_data) -> void:
	$main_theme.stop()
	var battle = battle_tscn.instantiate()
	battle.current_enemy = data
	battle.enemy_despawn = enemy
	battle.name = "CurrentBattle"
	battle.battle_finished.connect(_on_battle_finished)
	battle.battle_lost.connect(_on_battle_lost)

	add_child(battle)
	global.player.get_node("Camera2D").enabled = false
	get_tree().paused = true
	battle.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_battle_finished(enemy_node):
	$main_theme.play()
	get_tree().paused = false 
	global.player.get_node("Camera2D").enabled = true
	enemy_node.queue_free()
	$CurrentBattle.queue_free()
	
func _on_battle_lost():
	get_tree().paused = false 
	$CurrentBattle.queue_free()
	global.reset()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		global.points += 1
		print(global.points)
	if global.points >= 5:
		global.win()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("ball"):
		global.points -= 1
		
