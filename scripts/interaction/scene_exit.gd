# Scene Exit
# Placed at the edges of a scene. When the player walks into it,
# transitions to the connected scene.

class_name SceneExit
extends Area2D

## Path to the scene to load
@export_file("*.tscn") var target_scene: String = ""
## Which entry point to spawn at in the target scene
@export var target_entry_point: String = "default"


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		SceneManager.go_to(target_scene, target_entry_point)
