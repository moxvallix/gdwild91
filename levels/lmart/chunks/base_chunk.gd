class_name LMartChunk
extends Node2D

@onready var floorplan: LMartChunkLayer = get_node("%Floorplan")
@onready var items: LMartChunkLayer = get_node("%Items")

func _ready() -> void:
	print("READY", floorplan)

func copy_to(chunk: LMartChunk, start_pos: Vector2i) -> void:
	%Floorplan.copy_to(chunk.floorplan, start_pos)
	%Items.copy_to(chunk.items, start_pos)

func check_valid_spawn(chunk: LMartChunk, start_pos: Vector2i) -> bool:
	return (
		%Floorplan.check_valid_spawn(chunk.floorplan, start_pos) and
		%Items.check_valid_spawn(chunk.items, start_pos)
	)
