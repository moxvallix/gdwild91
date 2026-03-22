extends CharacterBody2D


const SPEED = 300
const JUMP_VELOCITY = -400.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var object_of_intrest: Node2D
var temp_OOI: Node2D
var home_position: Vector2

@export var Patrol_path: Path2D
var patrol_index = 0

var move_threshold: int = 70

func _ready() -> void:
	if !Patrol_path:
		home_position = self.get_global_transform().origin

func patrol():
	nav_agent.target_position = Patrol_path.curve.get_point_position(patrol_index)
	nav_agent.get_next_path_position()
	var next_nav_point: Vector2 = nav_agent.get_next_path_position()
	if (self.global_transform.origin - nav_agent.target_position).length() > move_threshold:
		velocity = ((next_nav_point - transform.origin).normalized() * SPEED)
	else:
		var temp_index = patrol_index+1
		if temp_index >  Patrol_path.curve.get_baked_points().size():
			temp_index = 0
			patrol_index = temp_index
		patrol_index = temp_index

func _physics_process(delta: float) -> void:
	if object_of_intrest:
		nav_agent.target_position = object_of_intrest.global_transform.origin
		nav_agent.get_next_path_position()
		var next_nav_point: Vector2 = nav_agent.get_next_path_position()
		if (self.global_transform.origin - nav_agent.target_position).length() > move_threshold:
			velocity = ((next_nav_point - transform.origin).normalized() * SPEED)
		else:
			velocity = Vector2(0,0)
	elif home_position:
		nav_agent.target_position = home_position
		nav_agent.get_next_path_position()
		var next_nav_point: Vector2 = nav_agent.get_next_path_position()
		if (self.global_transform.origin - nav_agent.target_position).length() > move_threshold:
			velocity = ((next_nav_point - transform.origin).normalized() * SPEED)
	elif Patrol_path:
		patrol()
	else:
		velocity = Vector2(0,0)
	if temp_OOI:
		self.rotation += self.get_angle_to(temp_OOI.global_position) * delta
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
			body.followed = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	$player_loss_timer.start()


func _on_player_loss_timer_timeout() -> void:
	var names: PackedStringArray = []
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		names.append(body.name)
	if ! names.has("s"):
		if object_of_intrest:
			object_of_intrest.followed = false
			object_of_intrest = null
		if temp_OOI:
			temp_OOI = null
