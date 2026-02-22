extends Control

var cookies = 0
var cookies_per_click = 1

signal on_cookies_changed

func _on_click_button_button_down() -> void:
	cookies += cookies_per_click
	emit_signal("on_cookies_changed", cookies)
