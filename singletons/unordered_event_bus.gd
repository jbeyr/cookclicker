# use this for any events whose order of execution is not important
# as the order is not guaranteed because of the way Godot handles signals
extends Node


signal cookies_changed
signal total_cookies_changed
signal cookies_per_second_changed
signal cookies_per_click_changed
signal cookie_clicked(amount)

# game state machine (paused, running, etc)
signal game_state_changed

signal sfx_requested(sfx_name: String)

signal upgrade_purchased(upgrade_id: String, new_count: int)
signal upgrade_requested(upgrade_id: String)
signal upgrade_announced(data: UpgradeResource) # so we can create new upgrades on the fly via ui
signal game_reset
