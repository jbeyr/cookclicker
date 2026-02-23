extends Control

@export var cookies = 0.0
@export var cookies_per_click = 1.0
@export var autosave_interval = 60.0

func _notification(notif_type: int) -> void:
	if notif_type == NOTIFICATION_WM_CLOSE_REQUEST or notif_type == NOTIFICATION_APPLICATION_PAUSED:
		_save_game()

func _on_click_button_button_down() -> void:
	cookies += cookies_per_click
	EventBus.cookies_changed.emit(cookies)
	EventBus.cookie_clicked.emit(cookies_per_click)

func _save_game():
	var dat = {
		"cookies": cookies,
		"cookies_per_click": cookies_per_click
	}
	SaveManager.save_game(dat)

func _load_game():
	var dat = SaveManager.load_game()
	if not dat.is_empty():
		cookies = dat.get("cookies", 0)
		cookies_per_click = dat.get("cookies_per_click", 1)
	print("loaded game")

func _ready() -> void:
	_load_game()
	EventBus.cookies_changed.emit(cookies)
	
	# init autosave timer
	var timer = Timer.new()
	timer.timeout.connect(_save_game)
	add_child(timer)
	timer.start(autosave_interval)
