@tool
extends Button

@export var upgrade_data: UpgradeResource:
	set(value):
		upgrade_data = value
		_update_ui()

@onready var title_label: Label = $HBox/VBox/Title
@onready var cost_label: Label = $HBox/VBox/Cost
@onready var count_label: Label = $HBox/Count

func _ready() -> void:
	if not Engine.is_editor_hint():
		if upgrade_data:
			UnorderedEventBus.upgrade_announced.emit(upgrade_data)
			
		pressed.connect(_on_pressed)
		UnorderedEventBus.upgrade_purchased.connect(_on_upgrade_purchased)
		UnorderedEventBus.cookies_changed.connect(_on_cookies_changed)
		UnorderedEventBus.total_cookies_changed.connect(_on_total_cookies_changed)
	
	_update_ui()

func _on_pressed() -> void:
	if upgrade_data:
		print("Button pressed for ID: ", upgrade_data.id)
		UnorderedEventBus.upgrade_requested.emit(upgrade_data.id)
	else:
		print("Button pressed but NO UPGRADE DATA assigned!")

func _on_upgrade_purchased(id: String, new_count: int) -> void:
	if upgrade_data and id == upgrade_data.id:
		upgrade_data.count = new_count
		_update_ui()

func _on_cookies_changed(cookies: float) -> void:
	if upgrade_data:
		disabled = cookies < upgrade_data.get_cost()

func _on_total_cookies_changed(total: float) -> void:
	_update_visibility(total)

func _update_visibility(total: float) -> void:
	if upgrade_data and not Engine.is_editor_hint():
		var threshold = upgrade_data.base_cost * upgrade_data.unlock_cost_threshold
		visible = total >= threshold

func _update_ui() -> void:
	# in tool mode, @onready might not have run yet if the setter is called early
	# so we check if the labels exist and get them by name if they don't
	var t_label = title_label if title_label else get_node_or_null("HBox/VBox/Title")
	var c_label = cost_label if cost_label else get_node_or_null("HBox/VBox/Cost")
	var n_label = count_label if count_label else get_node_or_null("HBox/Count")

	if not upgrade_data or not t_label: return
	
	t_label.text = upgrade_data.title
	c_label.text = "Cost: " + str(int(upgrade_data.get_cost()))
	n_label.text = str(upgrade_data.count)
