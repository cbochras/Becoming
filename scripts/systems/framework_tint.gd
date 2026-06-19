# Framework Tint Controller
# Connects the FrameworkManager values to the tint shader uniforms.
# Attach to a ColorRect with the framework_tint shader material.

class_name FrameworkTint
extends ColorRect


func _ready() -> void:
	# Full-screen overlay, no mouse interaction
	anchors_preset = Control.PRESET_FULL_RECT
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(_delta: float) -> void:
	if not material or not material is ShaderMaterial:
		return
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("vairagya", FrameworkManager.get_world_value("vairagya"))
	mat.set_shader_parameter("nihilism", FrameworkManager.get_world_value("nihilism"))
	mat.set_shader_parameter("absurdism", FrameworkManager.get_world_value("absurdism"))
	mat.set_shader_parameter("existentialism", FrameworkManager.get_world_value("existentialism"))
