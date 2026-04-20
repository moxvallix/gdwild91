extends Node2D

@export var steal_time: float = 5.0
@export var value: int = 10
@export var frame_after_steal: int = -1

@onready var outline_shader: Shader = load("res://levels/lmart/items/outline.gdshader")

var stolen := false
var in_range := false
var mouseover := false
var steal_timer: Timer
var player: Player

func _ready() -> void:
	var mat: ShaderMaterial = ShaderMaterial.new()
	mat.shader = outline_shader
	mat.set_shader_parameter("outline_thickness", 0.0)
	mat.set_shader_parameter("outline_color", Vector4(1.0, 1.0, 1.0, 1.0))
	%Viewport.material = mat
	
	steal_timer = Timer.new()
	steal_timer.autostart = false
	steal_timer.one_shot = true
	steal_timer.timeout.connect(steal_completed)
	
	add_child(steal_timer)

func _process(delta: float) -> void:
	if not steal_timer.is_stopped():
		%StealProgress.visible = true
		%StealProgress.value = (1 - (steal_timer.time_left / steal_time)) * 100.0
	else:
		%StealProgress.visible = false

func being_stolen():
	return not steal_timer.is_stopped()

func can_steal():
	return not stolen and not being_stolen() and in_range

func steal() -> void:
	steal_timer.wait_time = steal_time
	steal_timer.start()
	hide_highlight()
	add_to_player_steal_list()

func cancel_steal():
	steal_timer.stop()
	%StealProgress.value = 0
	remove_from_player_steal_list()

func steal_completed():
	stolen = true
	hide_highlight()
	Stats.add_money(value)
	if player != null: spawn_steal_animation(player)
	remove_from_player_steal_list()
	if frame_after_steal < 0:
		%Viewport.hide()
	else:
		%Icon.frame = frame_after_steal
		%ClickZone.hide()

func spawn_steal_animation(player: Node2D):
	var fake_item := CollectedItem.new()
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = %Icon.sprite_frames
	sprite.frame = %Icon.frame
	
	fake_item.end_pos = to_local(player.global_position)
	
	fake_item.add_child(sprite)
	add_child(fake_item)

func show_highlight():
	var mat: ShaderMaterial = %Viewport.material
	mat.set_shader_parameter("outline_thickness", 4.0)

func focus_highlight():
	var mat: ShaderMaterial = %Viewport.material
	mat.set_shader_parameter("outline_color", Vector4(0.2, 0.91, 0.165, 1.0))
	%ClickZone.mouse_default_cursor_shape = Input.CURSOR_POINTING_HAND

func unfocus_highlight():
	var mat: ShaderMaterial = %Viewport.material
	mat.set_shader_parameter("outline_color", Vector4(1.0, 1.0, 1.0, 1.0))
	%ClickZone.mouse_default_cursor_shape = Input.CURSOR_ARROW

func hide_highlight():
	var mat: ShaderMaterial = %Viewport.material
	mat.set_shader_parameter("outline_thickness", 0.0)

func enter_range():
	if stolen: return
	
	in_range = true
	show_highlight()
	if mouseover: focus_highlight()

func exit_range():
	in_range = false
	hide_highlight()

func exit_steal_cancel_range():
	if being_stolen(): cancel_steal()

func add_to_player_steal_list():
	if not player: return
	
	player.items_being_stolen.push_back(self)

func remove_from_player_steal_list():
	if not player: return
	
	var idx = player.items_being_stolen.find(self)
	if idx < 0: return
	
	player.items_being_stolen.remove_at(idx)

# Signals
func _on_click_zone_gui_input(event: InputEvent) -> void:
	if not can_steal(): return
	
	if event.is_action_pressed("steal"):
		steal()

func _on_click_zone_mouse_entered() -> void:
	mouseover = true
	if can_steal(): focus_highlight()

func _on_click_zone_mouse_exited() -> void:
	mouseover = false
	if stolen: return
	unfocus_highlight()

func _on_interaction_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		enter_range()

func _on_interaction_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		exit_range()

func _on_steal_cancel_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		exit_steal_cancel_range()
