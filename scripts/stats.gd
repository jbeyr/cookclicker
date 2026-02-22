extends VBoxContainer

@onready var cookie_label = $Label

func _on_game_on_cookies_changed(cookies: int) -> void:
	cookie_label.text = str(cookies) + " cookies"