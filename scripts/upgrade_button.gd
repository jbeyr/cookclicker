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
			EventBus.upgrade_announced.emit(upgrade_data)
			
		pressed.connect(_on_pressed)
		EventBus.upgrade_purchased.connect(_on_upgrade_purchased)
		EventBus.cookies_changed.connect(_on_cookies_changed)
	
	_update_ui()

func _on_pressed():
	if upgrade_data:
		print("Button pressed for ID: ", upgrade_data.id)
		EventBus.upgrade_requested.emit(upgrade_data.id)
	else:
		print("Button pressed but NO UPGRADE DATA assigned!")

func _on_upgrade_purchased(id: String, new_count: int):
	if upgrade_data and id == upgrade_data.id:
		upgrade_data.count = new_count
		_update_ui()

func _on_cookies_changed(cookies: float):
	if upgrade_data:
		disabled = cookies < upgrade_data.get_cost()

func _update_ui():
	# In tool mode, @onready might not have run yet if the setter is called early
	var t_label = title_label if title_label else get_node_or_null("HBox/VBox/Title")
	var c_label = cost_label if cost_label else get_node_or_null("HBox/VBox/Cost")
	var n_label = count_label if count_label else get_node_or_null("HBox/Count")

	if not upgrade_data or not t_label: return
	
	t_label.text = upgrade_data.title
	c_label.text = "Cost: " + str(int(upgrade_data.get_cost()))
	n_label.text = str(upgrade_data.count)
