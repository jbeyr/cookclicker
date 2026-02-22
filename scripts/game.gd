extends Control

const save_path = "user://userdata.save"

@export var cookies = 0
@export var cookies_per_click = 1
@export var autosave_interval = 60.0

signal on_cookies_changed

func _notification(notif_type: int) -> void:
	if notif_type == NOTIFICATION_WM_CLOSE_REQUEST or notif_type == NOTIFICATION_APPLICATION_PAUSED:
		savegame()

func _on_click_button_button_down() -> void:
	cookies += cookies_per_click
	on_cookies_changed.emit(cookies)

func savegame():
	var dat = {
		"cookies": cookies,
		"cookies_per_click": cookies_per_click
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if (file == null):
		print("Failed to open save file for writing.")
		return
	
	file.store_var(dat)
	file.close()
	print("saved game")

func loadgame():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if (file == null):
		print("Failed to open save file for reading.")
		return
	
	var dat = file.get_var()
	cookies = dat.get("cookies", 0)
	cookies_per_click = dat.get("cookies_per_click", 1)
	file.close()
	print("loaded game")

func _ready() -> void:
	loadgame()
	emit_signal("on_cookies_changed", cookies)
	
	# init autosave timer
	var timer = Timer.new()
	timer.timeout.connect(savegame)
	add_child(timer)	
	timer.start(autosave_interval)
