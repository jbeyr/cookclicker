extends VBoxContainer

@onready var cookie_label = $CookiesLabel
@onready var per_second_label = $PerSecondLabel

func _ready() -> void:
	EventBus.cookies_changed.connect(_on_cookies_changed)
	EventBus.cookies_per_second_changed.connect(_on_cps_changed)

func _on_cookies_changed(cookies) -> void:
	cookie_label.text = str(int(cookies)) + " cookies"

func _on_cps_changed(cps) -> void:
	per_second_label.text = String.num(cps) + " cookies/sec"
