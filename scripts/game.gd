extends Control

@export var cookies = 0.0
@export var upgrade_definitions: Array[UpgradeResource] = []
@export var cookies_per_click = 1.0
@export var cookies_per_second = 0.0
@export var click_multiplier = 1.0
@export var double_click_chance = 0.0
@export var autosave_interval = 60.0

var upgrades: Dictionary = {}

func _notification(notif_type: int) -> void:
	if notif_type == NOTIFICATION_WM_CLOSE_REQUEST or notif_type == NOTIFICATION_APPLICATION_PAUSED:
		_save_game()

func _on_click_button_button_down() -> void:
	var amt = cookies_per_click * click_multiplier
	if randf() < double_click_chance:
		amt *= 2.0
	
	cookies += amt
	EventBus.cookies_changed.emit(cookies)
	EventBus.cookie_clicked.emit(amt)

func _process(delta: float) -> void:
	if cookies_per_second > 0:
		cookies += cookies_per_second * delta
		EventBus.cookies_changed.emit(cookies)

func _save_game():
	var upgrade_data = {}
	for id in upgrades:
		upgrade_data[id] = upgrades[id].count
		
	var dat = {
		"cookies": cookies,
		"upgrades": upgrade_data
	}
	SaveManager.save_game(dat)

func _load_game():
	var dat = SaveManager.load_game()
	if not dat.is_empty():
		cookies = dat.get("cookies", 0.0)
		var upgrade_counts = dat.get("upgrades", {})
		for id in upgrade_counts:
			if upgrades.has(id):
				upgrades[id].count = upgrade_counts[id]
	
	_recalculate_stats()
	
	# Sync UI after loading
	for id in upgrades:
		EventBus.upgrade_purchased.emit(id, upgrades[id].count)
		
	print("loaded game")

# children run _ready() before the parent so if we connect in _ready() we might miss signals
# connect to signals in _enter_tree() instead of _ready() to avoid this
func _enter_tree() -> void:
	EventBus.upgrade_requested.connect(_on_upgrade_requested)
	EventBus.upgrade_announced.connect(_on_upgrade_announced)

func _ready() -> void:
	_init_upgrades()
	_load_game()
	
	EventBus.cookies_changed.emit(cookies)
	EventBus.cookies_per_second_changed.emit(cookies_per_second)
	
	# init autosave timer
	var timer = Timer.new()
	timer.timeout.connect(_save_game)
	add_child(timer)
	timer.start(autosave_interval)

func _init_upgrades():
	for upgrade in upgrade_definitions:
		var up_instance = upgrade.duplicate()
		upgrades[up_instance.id] = up_instance

func _on_upgrade_announced(data: UpgradeResource):
	if not upgrades.has(data.id):
		# Create a local state instance of the resource
		var up_instance = data.duplicate()
		upgrades[up_instance.id] = up_instance
		_recalculate_stats()
		print("Auto-discovered upgrade: ", up_instance.id)

func _on_upgrade_requested(id: String):
	if not upgrades.has(id):
		print("ERROR: Game doesn't know about upgrade ID: ", id)
		return
		
	var up = upgrades[id]
	var cost = up.get_cost()
	
	if cookies >= cost:
		cookies -= cost
		up.count += 1
		_recalculate_stats()
		EventBus.cookies_changed.emit(cookies)
		EventBus.upgrade_purchased.emit(id, up.count)
		print("SUCCESS: Purchased ", id, ". New count: ", up.count)
	else:
		print("FAIL: Not enough cookies for ", id, " (Need ", cost, ")")

func _recalculate_stats():
	var new_cpc = 1.0
	var new_cps = 0.0
	var new_mult = 1.0
	var new_crit = 0.0
	
	for id in upgrades:
		var up = upgrades[id]
		new_cpc += up.cookies_per_click_bonus * up.count
		new_cps += up.cookies_per_second_bonus * up.count
		new_mult += up.click_multiplier_bonus * up.count
		new_crit += up.double_click_chance * up.count
	
	cookies_per_click = new_cpc
	cookies_per_second = new_cps
	click_multiplier = new_mult
	double_click_chance = new_crit
	
	EventBus.cookies_per_second_changed.emit(cookies_per_second)
	EventBus.cookies_per_click_changed.emit(cookies_per_click)
