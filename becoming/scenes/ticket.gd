extends Area2D

signal selected(object_name)

@export var object_id: String

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("selected", object_id)
