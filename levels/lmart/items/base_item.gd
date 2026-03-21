extends Node2D

@export var steal_time: int = 5
@export var value: int = 10
@export var frame_after_steal: int = -1

@onready var outline_shader: Shader = load("res://levels/lmart/items/outline.gdshader")

var stolen := false
var in_range := false
var mouseover := false

func _ready() -> void:
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = outline_shader
	material.set_shader_parameter("outline_thickness", 0)
	material.set_shader_parameter("outline_color", Vector4(0.2, 0.91, 0.165, 1.0))
	%Icon.material = material

func steal() -> void:
	stolen = true
	if frame_after_steal < 0:
		%Icon.hide()
	else:
		%Icon.frame = frame_after_steal
		hide_highlight()

func show_highlight():
	var material: ShaderMaterial = %Icon.material
	material.set_shader_parameter("outline_thickness", 4)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func hide_highlight():
	var material: ShaderMaterial = %Icon.material
	material.set_shader_parameter("outline_thickness", 0)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func enter_range():
	in_range = true
	if mouseover: show_highlight()

func exit_range():
	in_range = false
	hide_highlight()

# Signals

func _on_click_zone_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if stolen or not in_range: return
	
	if event.is_action_pressed("steal"):
		steal()

func _on_click_zone_mouse_entered() -> void:
	mouseover = true
	if stolen or not in_range: return
	show_highlight()

func _on_click_zone_mouse_exited() -> void:
	mouseover = false
	if stolen: return
	hide_highlight()

func _on_interaction_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): enter_range()

func _on_interaction_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): exit_range()
