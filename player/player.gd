class_name Player
extends CharacterBody2D

const SPEED = 800.0
var followed: bool = false
var dir := 2
var items_being_stolen: Array[Node2D]

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_x := Input.get_axis("move_left", "move_right")
	var dir_y := Input.get_axis("move_up", "move_down")
	
	if dir_x:
		velocity.x = dir_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if dir_y:
		velocity.y = dir_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if dir_y < 0:
		dir = 0
	elif dir_y > 0:
		dir = 1
	elif dir_x > 0:
		dir = 2
	elif dir_x < 0:
		dir = 3

	if dir_x or dir_y:
		set_run_anim()
	else:
		set_idle_anim()

	move_and_slide()

func set_run_anim():
	match dir:
		0:
			%Sprite.animation = &"run_up"
			%Sprite.flip_h = false
		1:
			%Sprite.animation = &"run_down"
			%Sprite.flip_h = false
		2:
			%Sprite.animation = &"run_side"
			%Sprite.flip_h = false
		3:
			%Sprite.animation = &"run_side"
			%Sprite.flip_h = true

func set_idle_anim():
	pass

func reload():
	get_tree().reload_current_scene()

func is_stealing() -> bool:
	return items_being_stolen.size() > 0

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if followed:
		if body.is_in_group("Enemy"):
			call_deferred("reload")
	if body.is_in_group("Enemy"):
		body._on_area_2d_body_entered(self)
		body.temp_OOI = self
