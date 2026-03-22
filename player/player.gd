extends CharacterBody2D

const SPEED = 600.0
var followed: bool = false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_x := Input.get_axis("move_left", "move_right")
	var dir_y := Input.get_axis("move_up", "move_down")
	
	if dir_x > 0:
		%Sprite.flip_h = false

	if dir_x < 0:
		%Sprite.flip_h = true

	if dir_x:
		velocity.x = dir_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if dir_y:
		velocity.y = dir_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func reload():
	get_tree().reload_current_scene()

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if followed:
		if body.is_in_group("Enemy"):
			call_deferred("reload")
	if body.is_in_group("Enemy"):
		body._on_area_2d_body_entered(self)
		body.temp_OOI = self
