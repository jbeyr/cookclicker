# autoloads/save_manager.gd
extends Node

const SAVE_PATH := "user://save_data.json"
const SETTINGS_PATH := "user://settings.json"

var game_data: Dictionary = {}
var settings_data: Dictionary = {}

func _ready() -> void:
	load_settings()

# --- Game Data ---
func save_game(data: Dictionary = {}) -> void:
	if not data.is_empty():
		game_data = data
	game_data["timestamp"] = Time.get_datetime_string_from_system()
	var json := JSON.stringify(game_data, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
		print("Game saved.")

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json := JSON.new()
		var result := json.parse(file.get_as_text())
		file.close()
		if result == OK:
			game_data = json.data
			return game_data
	return {}

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

# --- Settings ---
func save_settings(data: Dictionary = {}) -> void:
	if not data.is_empty():
		settings_data.merge(data, true)
	var json := JSON.stringify(settings_data, "\t")
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()

func load_settings() -> Dictionary:
	if not FileAccess.file_exists(SETTINGS_PATH):
		settings_data = get_default_settings()
		save_settings()
		return settings_data
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file:
		var json := JSON.new()
		if json.parse(file.get_as_text()) == OK:
			settings_data = json.data
		file.close()
	return settings_data

func get_default_settings() -> Dictionary:
	return {
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"fullscreen": false,
	}

func apply_audio_settings() -> void:
	_set_bus_volume("Master", settings_data.get("master_volume", 1.0))
	_set_bus_volume("Music", settings_data.get("music_volume", 0.8))
	_set_bus_volume("SFX", settings_data.get("sfx_volume", 1.0))

func _set_bus_volume(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, linear_to_db(linear))
		AudioServer.set_bus_mute(idx, linear <= 0.0)