extends Node2D

var chosen_object: String = ""
var archivist_state: String = "digging"

@onready var archivist = $Archivist
@onready var ui_text = $UI/InteractionText
@onready var objects = $Objects

func _ready():
	# Hide objects until box opens
	objects.visible = false
	$Box.visible = false 
	$UI/Fade.visible = false
	ui_text.text = ""
	
	# Connect object signals
	$Objects/Cassette.selected.connect(_on_object_selected)
	$Objects/Ticket.selected.connect(_on_object_selected)
	$Objects/Photo.selected.connect(_on_object_selected)
	
	# Start scene
	_enter_scene()


func _enter_scene():
	# Let player take in the space
	await get_tree().create_timer(2.0).timeout
	
	ui_text.text = "A figure is kneeling in wet soil.\nBare hands. No tools."
	archivist_state = "digging"
	
	await get_tree().create_timer(4.0).timeout
	
	# Box reveal
	ui_text.text = "They pull something from the earth.\nA rusted metal box."
	$Box.visible = true
	$Box.modulate.a = 0.0
	var box_tween = create_tween()
	box_tween.tween_property($Box, "modulate:a", 1.0, 1.5)
	
	await get_tree().create_timer(3.0).timeout
	
	# Archivist steps back
	var tween = create_tween()
	tween.tween_property(archivist, "position", archivist.position + Vector2(40, 0), 1.5)
	archivist_state = "standing"
	
	await get_tree().create_timer(2.0).timeout
	
	ui_text.text = "\"Pick one.\""
	
	await get_tree().create_timer(1.5).timeout
	
	# Reveal objects — player can now click
	objects.visible = true
	objects.modulate.a = 0.0
	var fade_in = create_tween()
	fade_in.tween_property(objects, "modulate:a", 1.0, 1.0)
	
	ui_text.text = ""


func _on_object_selected(object_id):
	if chosen_object != "":
		return
	
	chosen_object = object_id
	ui_text.text = ""
	
	_freeze_world()
	_react_archivist(object_id)
	await get_tree().create_timer(2.0).timeout
	_resolve_scene()


func _freeze_world():
	objects.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Dim unchosen objects
	for obj in objects.get_children():
		if obj.name.to_lower() != chosen_object:
			var tween = create_tween()
			tween.tween_property(obj, "modulate:a", 0.2, 1.0)


func _react_archivist(object_id):
	match object_id:
		"cassette":
			archivist.call("slight_head_tilt")
		"ticket":
			archivist.call("pause_longer")
		"photo":
			archivist.call("step_back")


func _resolve_scene():
	match chosen_object:
		"cassette":
			ui_text.text = "The tape clicks in your hand.\nThe label is warm — like it was just held by someone else."
		"ticket":
			ui_text.text = "The ink feels wet, even now.\nA destination you almost remember."
		"photo":
			ui_text.text = "The face is gone.\nBut your hands remember holding this before."
	
	await get_tree().create_timer(4.0).timeout
	
	ui_text.text = "The remaining objects go back in the box.\nClosed. Not locked.\n\nThe way you close a book you know you'll reopen."
	
	await get_tree().create_timer(4.0).timeout
	_fade_out()


func _fade_out():
	ui_text.text = ""
	$UI/Fade.visible = true
	$UI/Fade.modulate.a = 0
	
	var tween = create_tween()
	tween.tween_property($UI/Fade, "modulate:a", 1.0, 2.0)
	
	await tween.finished
	print("  ► Scene 1 complete. Chosen: %s" % chosen_object)
