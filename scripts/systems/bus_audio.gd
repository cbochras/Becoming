# Bus Audio — Distant Engine Sound
# Plays a subtle bus engine sound when the bus arrives/departs.
# The player will stop noticing this by hour two. But it's always there.

extends Node

var _arrive_player: AudioStreamPlayer
var _depart_player: AudioStreamPlayer


func _ready() -> void:
	# Create placeholder audio players (replace with real sounds later)
	_arrive_player = AudioStreamPlayer.new()
	_arrive_player.volume_db = -18.0
	_arrive_player.bus = "SFX"
	add_child(_arrive_player)

	_depart_player = AudioStreamPlayer.new()
	_depart_player.volume_db = -18.0
	_depart_player.bus = "SFX"
	add_child(_depart_player)

	BusSystem.bus_arrived.connect(_on_arrive)
	BusSystem.bus_departed.connect(_on_depart)


func _on_arrive() -> void:
	# For now just print — replace with actual audio later
	print("[BUS] Arrived — engine idling. Player can board.")


func _on_depart() -> void:
	print("[BUS] Departed — engine fading. Buses missed: ", BusSystem.get_departure_count())
