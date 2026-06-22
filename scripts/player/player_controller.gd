# Player Controller
# Handles movement within composed scene frames.
# Point-and-click + WASD hybrid.

class_name PlayerController
extends CharacterBody2D

signal arrived_at(position: Vector2)
signal interacted_with(interactable: Node)
signal stopped_moving
signal started_moving

@export var move_speed: float = 120.0
@export var arrival_threshold: float = 5.0

var _target_position: Vector2 = Vector2.ZERO
var _is_moving := false
var _nearby_interactable: Node = null

@onready var _sprite: Node2D = $Sprite
@onready var _interaction_area: Area2D = $InteractionArea


func _ready() -> void:
	_target_position = global_position
	add_to_group("player")
	if _interaction_area:
		_interaction_area.area_entered.connect(_on_interactable_entered)
		_interaction_area.area_exited.connect(_on_interactable_exited)


func _unhandled_input(event: InputEvent) -> void:
	# Point and click movement
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_target_position = get_global_mouse_position()
			if not _is_moving:
				_is_moving = true
				started_moving.emit()

	# Interact
	if event.is_action_pressed("interact"):
		_try_interact()


func _physics_process(delta: float) -> void:
	# WASD input overrides click target
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")

	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * move_speed
		_target_position = global_position  # Cancel click target
		if not _is_moving:
			_is_moving = true
			started_moving.emit()
	else:
		# Move toward click target
		var distance := global_position.distance_to(_target_position)
		if distance > arrival_threshold:
			var direction := global_position.direction_to(_target_position)
			velocity = direction * move_speed
			if not _is_moving:
				_is_moving = true
				started_moving.emit()
		else:
			velocity = Vector2.ZERO
			if _is_moving:
				_is_moving = false
				stopped_moving.emit()
				arrived_at.emit(global_position)

	move_and_slide()

	# Track stillness/movement for framework reading
	GameState.record_movement(_is_moving, delta)

	# Flip sprite based on direction
	if _sprite and velocity.x < -1:
		_sprite.scale.x = -abs(_sprite.scale.x)
	elif _sprite and velocity.x > 1:
		_sprite.scale.x = abs(_sprite.scale.x)


func _try_interact() -> void:
	if _nearby_interactable and _nearby_interactable.has_method("interact"):
		_nearby_interactable.interact()
		interacted_with.emit(_nearby_interactable)


func _on_interactable_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent.has_method("interact"):
		_nearby_interactable = parent
		if parent.has_method("show_hint"):
			parent.show_hint()


func _on_interactable_exited(area: Area2D) -> void:
	var parent := area.get_parent()
	if _nearby_interactable == parent:
		if parent.has_method("hide_hint"):
			parent.hide_hint()
		_nearby_interactable = null
		_nearby_interactable = null
		if parent.has_method("hide_hint"):
			parent.hide_hint()
