class_name LMartChunk
extends Node2D

@onready var floor: LMartChunkLayer = get_node("%Floor")
@onready var walls: LMartChunkLayer = get_node("%Walls")
@onready var items: LMartChunkLayer = get_node("%Items")

func _ready() -> void:
	pass

func copy_to(chunk: LMartChunk, start_pos: Vector2i) -> void:
	%Floor.copy_to(chunk.floor, start_pos)
	%Walls.copy_to(chunk.walls, start_pos)
	%Items.copy_to(chunk.items, start_pos)

func check_valid_spawn(chunk: LMartChunk, start_pos: Vector2i) -> bool:
	return (
		%Floor.check_valid_spawn(chunk.floor, start_pos) and
		%Walls.check_valid_spawn(chunk.walls, start_pos) and
		%Items.check_valid_spawn(chunk.items, start_pos)
	)
