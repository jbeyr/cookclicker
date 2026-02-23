extends VBoxContainer

@onready var cookies_label: Label = $CookiesLabel
@onready var per_second_label: Label = $PerSecondLabel

func _ready() -> void:
	UnorderedEventBus.cookies_changed.connect(_on_cookies_changed)
	UnorderedEventBus.cookies_per_second_changed.connect(_on_cps_changed)

func _on_cookies_changed(cookies: float) -> void:
	cookies_label.text = str(int(cookies)) + " cookies"

func _on_cps_changed(cps: float) -> void:
	per_second_label.text = String.num(cps) + " cookies/sec"
