extends VBoxContainer

@export var upgrade_button_script: Script = preload("res://scripts/upgrade_button.gd")

func _ready() -> void:
	# dumb hacky delay to ensure game.gd has initialized upgrades
	await get_tree().process_frame
	
	var game_node = get_tree().root.find_child("Game", true, false)
	if game_node:
		for upgrade_id in game_node.upgrades:
			var upgrade = game_node.upgrades[upgrade_id]
			_create_upgrade_button(upgrade)

func _create_upgrade_button(upgrade: UpgradeResource):
	var btn = Button.new()
	btn.set_script(upgrade_button_script)
	btn.upgrade_data = upgrade
	
	btn.custom_minimum_size.y = 80
	
	var hbox = HBoxContainer.new()
	hbox.name = "HBox"
	hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(hbox)
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(vbox)
	
	var title = Label.new()
	title.name = "Title"
	title.text = upgrade.title
	vbox.add_child(title)
	
	var cost = Label.new()
	cost.name = "Cost"
	cost.add_theme_font_size_override("font_size", 12)
	vbox.add_child(cost)
	
	var count = Label.new()
	count.name = "Count"
	count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	count.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	count.text = "0"
	hbox.add_child(count)
	
	add_child(btn)
