extends CanvasLayer

func _init() -> void:
	Stats.paw_count_change.connect(_on_paw_count_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%Balance.text = "{0}".format([Stats.money])

func _on_paw_count_change(count):
	var active_color := Color(0, 1, 0)
	var inactive_color := Color(0.5, 0.5, 0.5)
	
	%Paw1.modulate = active_color
	%Paw2.modulate = active_color
	%Paw3.modulate = active_color
	
	if count >= 1:
		%Paw3.modulate = inactive_color
	if count >= 2:
		%Paw2.modulate = inactive_color
	if count >= 3:
		%Paw1.modulate = inactive_color
