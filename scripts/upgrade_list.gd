extends GridContainer

@export var upgrade_button_script: Script = preload("res://scripts/upgrade_button.gd")

func _ready() -> void:
	columns = 3
	# Ensure the grid handles its own sizing or is inside a container that does
	custom_minimum_size = Vector2(300, 0)
	
	# dumb hacky delay to ensure game.gd has initialized upgrades
	await get_tree().process_frame
	
	var game_node = get_tree().root.find_child("Game", true, false)
	if game_node:
		for upgrade_id in game_node.upgrades:
			var upgrade = game_node.upgrades[upgrade_id]
			_create_upgrade_button(upgrade)

func _create_upgrade_button(upgrade: UpgradeResource) -> void:
	var btn = Button.new()
	btn.set_script(upgrade_button_script)
	btn.upgrade_data = upgrade
	
	# Compact size for grid
	btn.custom_minimum_size = Vector2(100, 100)
	btn.focus_mode = Control.FOCUS_NONE # Disable focus navigation
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn.add_child(vbox)
	
	var title = Label.new()
	title.name = "Title"
	title.text = upgrade.title
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 10)
	vbox.add_child(title)
	
	var cost = Label.new()
	cost.name = "Cost"
	cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cost.add_theme_font_size_override("font_size", 10)
	vbox.add_child(cost)
	
	var count = Label.new()
	count.name = "Count"
	count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count.text = "0"
	vbox.add_child(count)
	
	add_child(btn)
