extends Node2D

@export var steal_time: int = 5
@export var value: int = 10

func steal() -> void:
	queue_free()
