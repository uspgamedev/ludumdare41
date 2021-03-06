extends Node2D

signal ended_night

var clock
var transition_scene = preload("res://transition/Transition.tscn")
var actual_map
var is_day = true
var crops_set = false

func _ready():
	clock = $HUD/Status/UpperRight/Clock
	actual_map = $Map
	if has_node("Play"):
		$Play._play()

func get_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.empty():
		return null
	return players[0]

func get_inventory():
	return $Inventory

func get_db():
	return get_node("/root/Database")

func get_hud():
	return get_node("HUD")

func get_flags():
	return $Flags

func get_cropmatrix():
	return $CropMatrix

func is_daytime():
	return self.is_day

func get_daytime():
	clock.get_daytime()

func get_day():
	clock.get_day()

func sleep_and_save():
	if has_node("Play"):
		get_flags().spend_day()
		$Play.save_game()

func execute_cutscene(name):
	return get_node("Map/Cutscenes").execute_cutscene(name)

func end_night():
	emit_signal("ended_night")
	var transition = transition_scene.instance()
	var map = $Map
	add_child(transition)
	map.get_node("BGM").fade_out()
	transition.play("morning")
	yield(transition, "got_dark")
	clock.end_night()
	var new_map = preload("res://map/house_daytime.tscn").instance()
	map.queue_free()
	$CropMatrix.grow_all()
	is_day = true
	crops_set = false
	yield(get_tree(), "physics_frame")
	add_child(new_map)
	prevent_player_input(true)

func end_day():
	var transition = transition_scene.instance()
	var map = $Map
	map.get_node("BGM").fade_out()
	add_child(transition)
	transition.play("night")
	yield(transition, "got_dark")
	if map.nighttime != null:
		var new_map = load(map.nighttime).instance()
		map.queue_free()
		is_day = false
		crops_set = false
		yield(get_tree(), "physics_frame")
		add_child(new_map)
		prevent_player_input(true)

func pause_clock():
	clock.pause()

func unpause_clock():
	clock.unpause()

func update_clock():
	clock.update_bar()

func change_map(map_name):
	var transition = transition_scene.instance()
	add_child(transition)
	var map = $Map
	map.get_node("BGM").fade_out()
	var new_map = load("res://map/" + map_name + ".tscn").instance()
	transition.play("scene", 0.01)
	yield(transition, "got_dark")
	map.queue_free()
	yield(get_tree(), "physics_frame")
	add_child(new_map)
	prevent_player_input(true)

func prevent_player_input(b):
	var player = get_player()
	if player != null:
		player.get_node("InputNode").prevent_input(b)
