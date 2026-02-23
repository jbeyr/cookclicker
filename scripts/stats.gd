extends VBoxContainer

@onready var cookie_label = $CookiesLabel

func _ready() -> void:
	EventBus.cookies_changed.connect(_on_cookies_changed)

func _on_cookies_changed(cookies) -> void:
	cookie_label.text = str(int(cookies)) + " cookies"
