extends VBoxContainer

@onready var cookies_label = $CookiesLabel
@onready var per_second_label = $PerSecondLabel

func _ready() -> void:
	UnorderedEventBus.cookies_changed.connect(_on_cookies_changed)
	UnorderedEventBus.cookies_per_second_changed.connect(_on_cps_changed)

func _on_cookies_changed(cookies) -> void:
	cookies_label.text = str(int(cookies)) + " cookies"

func _on_cps_changed(cps) -> void:
	per_second_label.text = String.num(cps) + " cookies/sec"
