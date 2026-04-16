class_name Player
extends CharacterBody2D

enum FACING {
	UP, DOWN, RIGHT, LEFT
}

@export var facing_direction: FACING

const SPEED = 800.0
var followed: bool = false
var dir: FACING = FACING.RIGHT
var items_being_stolen: Array[Node2D]

func _ready() -> void:
	dir = facing_direction
	set_run_anim()

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
		dir = FACING.UP
	elif dir_y > 0:
		dir = FACING.DOWN
	elif dir_x > 0:
		dir = FACING.RIGHT
	elif dir_x < 0:
		dir = FACING.LEFT

	if dir_x or dir_y:
		set_run_anim()
	else:
		set_idle_anim()

	move_and_slide()

func set_run_anim():
	match dir:
		FACING.UP:
			%Sprite.animation = &"run_up"
			%Sprite.flip_h = false
		FACING.DOWN:
			%Sprite.animation = &"run_down"
			%Sprite.flip_h = false
		FACING.RIGHT:
			%Sprite.animation = &"run_side"
			%Sprite.flip_h = false
		FACING.LEFT:
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
