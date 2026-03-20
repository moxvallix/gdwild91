extends CharacterBody2D


const SPEED = 300
const JUMP_VELOCITY = -400.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var object_of_intrest: Node2D

var move_threshold: int = 50

func _physics_process(delta: float) -> void:
	if object_of_intrest:
		nav_agent.target_position = object_of_intrest.global_transform.origin
		nav_agent.get_next_path_position()
		var next_nav_point: Vector2 = nav_agent.get_next_path_position()
		velocity = ((next_nav_point - transform.origin).normalized() * SPEED)
	else:
		velocity -= velocity * delta

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var ray = RayCast2D.new()
		owner.add_child(ray)
		ray.position = self.position
		ray.target_position = body.position - ray.position
		await get_tree().create_timer(0.01).timeout
		if ray.is_colliding():
			var ray_colider = ray.get_collider()
			if ray_colider != body:
				print("ray not passed")
				ray.queue_free()
			else:
				$Timer.start()
				ray.queue_free()
				print("ray passed")


func _on_timer_timeout() -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			object_of_intrest = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$player_loss_timer.start()


func _on_player_loss_timer_timeout() -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			object_of_intrest = body
			return
		else:
			pass
