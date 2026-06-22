# Bus System
# The ticking clock. The exit that closes.
# Bus arrives/departs every 20 minutes. After 3 hours, depot closes permanently.

extends Node

signal bus_arrived
signal bus_departed
signal depot_closed

## How often the bus comes (real seconds)
const BUS_INTERVAL := 120.0  # 2 minutes (testing — change to 1200 for release)
## When the depot closes permanently (real seconds)
const DEPOT_CLOSES_AT := 600.0  # 10 minutes (testing — change to 10800 for release)
## How long the bus waits at the depot (real seconds)
const BUS_WAIT_TIME := 30.0  # 30 seconds window to board (testing)

var time_elapsed := 0.0
var bus_is_here := false
var depot_is_open := true
var _bus_timer := 0.0
var _bus_wait_timer := 0.0
var _departure_count := 0


func _ready() -> void:
	# First bus is already gone (you missed it by sleeping)
	_bus_timer = BUS_INTERVAL
	_departure_count = 1
	print("[BUS] System active. Next bus in %.0f seconds." % BUS_INTERVAL)


func _process(delta: float) -> void:
	if not depot_is_open:
		return

	time_elapsed += delta

	# Check if depot should close
	if time_elapsed >= DEPOT_CLOSES_AT:
		_close_depot()
		return

	# Bus cycle
	if bus_is_here:
		_bus_wait_timer -= delta
		if _bus_wait_timer <= 0.0:
			_depart_bus()
	else:
		_bus_timer -= delta
		if _bus_timer <= 0.0:
			_arrive_bus()


func _arrive_bus() -> void:
	bus_is_here = true
	_bus_wait_timer = BUS_WAIT_TIME
	print("[BUS] Arrived. You have %.0f seconds to board." % BUS_WAIT_TIME)
	bus_arrived.emit()


func _depart_bus() -> void:
	bus_is_here = false
	_bus_timer = BUS_INTERVAL
	_departure_count += 1
	print("[BUS] Departed. Missed buses: %d. Next in %.0f sec." % [_departure_count, BUS_INTERVAL])
	bus_departed.emit()


func _close_depot() -> void:
	depot_is_open = false
	bus_is_here = false
	print("[BUS] DEPOT CLOSED. No more buses.")
	depot_closed.emit()


## Can the player board right now?
func can_board() -> bool:
	return bus_is_here and depot_is_open


## How many buses have left without you
func get_departure_count() -> int:
	return _departure_count


## Minutes until next bus (for debug)
func get_minutes_until_bus() -> float:
	if bus_is_here:
		return 0.0
	return _bus_timer / 60.0
