extends Node2D
signal battle_finished(enemy_despawn)
var current_enemy : enemy_data
var player = global.player_info
var play_stats : player_data = player
var battle_player_tscn = preload("res://scenes/player/battle_player.tscn")
var battle_enemy_tscn = preload("res://scenes/enemies/battle_enemy.tscn")
var bp: battle_player
var be: battle_enemy
var stop_distance : float = 50
var enemy_despawn 
var player_moving
var enemy_moving
signal player_move_finished
signal enemy_move_finished
var player_cd 
signal battle_lost

func _process(delta):
	if !$Control/Timer.is_stopped():
		$Control/HFlowContainer/attack.text = str(round($Control/Timer.time_left))
	else:
		$Control/HFlowContainer/attack.text = "attack"
		
func _ready():
	$battle_theme.play()
	battle_setup($startpos/player, $battle_enemy, true)
	battle_setup($startpos/enemy, $battle_enemy, false)
func battle_setup(startpos: Node2D, parent: Node2D, is_protag : bool):
	
	var pos = startpos.position + Vector2(0, -24)
	spawn(pos, parent, is_protag)
	
	
func spawn(pos: Vector2, parent: Node2D, is_protag : bool):
	if is_protag == true:
		bp = battle_player_tscn.instantiate()
		parent.add_child(bp)
		bp.setup(pos, player)
		player_cd = bp.get_node("attack_cd")
		bp.dead.connect(_on_battle_player_dead) 
	else: 	
		be = battle_enemy_tscn.instantiate()
		parent.add_child(be)
		be.setup(pos, current_enemy)
		be.ready_attack.connect(_on_battle_enemy_ready_attack)
		be.dead.connect(_on_battle_enemy_dead) 

	
func _on_attack_pressed() -> void:
	if enemy_moving == true or $Control/Timer.is_stopped() == false or player_moving == true:
		return
	be.get_node("ready_to_attack").paused = true
	$Control/Timer.wait_time = player_cd.wait_time
	player_moving = true
	var tween = create_tween()
	var player_start_pos = bp.global_position 
	var dir = (be.global_position - bp.global_position).normalized()
	var target = be.global_position - dir * stop_distance #
	tween.tween_property(bp, "global_position", target, 3.0)
	await tween.finished
	tween.stop()
	bp.anim_player.play("attack")
	await bp.anim_player.animation_finished
	be.take_damage(player.base_damage)
	$Control/damage_reader.text = "[center]{name} did {damage} damage [/center]".format({
	"name": player.name,
	"damage": player.base_damage
})
	var tween_back = create_tween()
	tween_back.tween_property(bp, "global_position", player_start_pos, 3.0)
	await tween_back.finished
	player_moving = false
	player_move_finished.emit()
	$Control/Timer.start()
	be.get_node("ready_to_attack").paused = false
func _on_special_pressed() -> void:
	pass # Replace with function body.


func _on_items_pressed() -> void:
	pass # Replace with function body.


func _on_pass_pressed() -> void:
	pass # Replace with function body.


func _on_battle_enemy_ready_attack() -> void:
	if player_moving == true:
		await player_move_finished
	enemy_moving = true
	player_cd.paused = true
	$Control/Timer.paused = true 
	print("itlives")
	var tween = create_tween()
	var enemy_start_pos = be.global_position 
	var dir = (bp.global_position - be.global_position).normalized()
	var target = bp.global_position - dir * stop_distance 
	tween.tween_property(be, "global_position", target, 3.0)
	await tween.finished
	tween.stop()
	be.anim_player.play("attack")
	await be.anim_player.animation_finished
	$Control/damage_reader.text = "[center]{name} did {damage} damage [/center]".format({
		"name" : current_enemy.name,
		"damage" : be.damage
	})
	bp.take_damage(current_enemy.damage)
	var tween_back = create_tween()
	tween_back.tween_property(be, "global_position", enemy_start_pos, 3.0)
	await tween_back.finished
	print("works")
	be.anim_player.play("idle")
	tween.stop()
	enemy_moving = false
	enemy_move_finished.emit()
	player_cd.paused = false
	$Control/Timer.paused = false 
	be.get_node("ready_to_attack").start()

	
	


func _on_battle_enemy_dead() -> void:
	await player_move_finished
	$battle_theme.stop()
	battle_finished.emit(enemy_despawn)
	global.player_info.current_hp = bp.current_hp
	global.save_player()


func _on_battle_player_dead() -> void:
	await enemy_move_finished
	battle_lost.emit()
