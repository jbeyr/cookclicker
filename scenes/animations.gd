extends MarginContainer

@onready var click_button = $MainVBox/CenterContainer/ClickButton
@onready var template = $"../../Indicators/Template"
@onready var indicators = $"../../Indicators"

func _ready() -> void:
	# Set pivot to center (200x200 button size)
	click_button.pivot_offset = click_button.size / 2
	EventBus.cookie_clicked.connect(_on_cookie_clicked)

func _on_click_button_button_down() -> void:
	print("button down")
	var tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_click_button_button_up() -> void:
	print("button up")
	var tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_cookie_clicked(amt) -> void:
	print("cookie physically clicked: " + str(amt))
	var idctr = template.duplicate()
	var amt_text = str(amt)
	if is_equal_approx(amt, round(amt)):
		amt_text = str(int(amt))
	idctr.text = "+" + amt_text
	idctr.position = get_global_mouse_position()
	idctr.visible = true # hidden by default, so change
	indicators.add_child(idctr)
	idctr.get_child(0).start() # dumb hack to start the animation, should probably be a better way to do this
