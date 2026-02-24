extends MarginContainer

@onready var click_button: TextureButton = $CenterContainer/ClickButton
@onready var template: Label = $"../../Indicators/Template"
@onready var indicators: Control = $"../../Indicators"

func _ready() -> void:
	# set pivot to center (200x200 button size) because im too dumb to find this in the editor
	click_button.pivot_offset = click_button.size / 2
	UnorderedEventBus.cookie_clicked.connect(_on_cookie_clicked)

func visual_pulse() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(0.9, 0.9), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_click_button_button_down() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_click_button_button_up() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_cookie_clicked(amt: float) -> void:
	visual_pulse()
	var idctr := template.duplicate() as Label
	var amt_text = str(amt)
	if is_equal_approx(amt, round(amt)):
		amt_text = str(int(amt))
	idctr.text = "+" + amt_text
	idctr.position = get_global_mouse_position()
	idctr.visible = true # hidden by default, so change
	indicators.add_child(idctr)
	idctr.get_child(0).start() # dumb hack to start the animation, should probably be a better way to do this
