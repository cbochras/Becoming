extends Interactable

@export var readable_text: Array = []
@export var source_name: String = ""


func _on_interact() -> void:
	if readable_text.is_empty():
		return

	var lines: Array = []
	for text in readable_text:
		lines.append({"text": text, "speaker": source_name})

	var dialogue_ui = get_tree().get_first_node_in_group("dialogue_system")
	if dialogue_ui and dialogue_ui.has_method("start"):
		dialogue_ui.start(lines, "")
