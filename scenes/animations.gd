extends MarginContainer

@onready var click_button = $CenterContainer/ClickButton

func _ready() -> void:
	# Set pivot to center (200x200 button size)
	click_button.pivot_offset = click_button.size / 2

func _on_click_button_button_down() -> void:
	print("button down")
	var tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_click_button_button_up() -> void:
	print("button up")
	var tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
