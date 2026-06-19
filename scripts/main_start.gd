# Main Start
# Minimal entry point. Waits for input, then transitions to the first scene.

extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		SceneManager.go_to("res://scenes/locations/bus_depot.tscn", "arrival")
