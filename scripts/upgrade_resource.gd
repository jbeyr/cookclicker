class_name UpgradeResource
extends Resource

@export var id: String
@export var title: String
@export var description: String
@export var base_cost: float
@export var cost_multiplier: float = 1.15

@export var cookies_per_click_bonus: float = 0.0
@export var cookies_per_second_bonus: float = 0.0
@export var click_multiplier_bonus: float = 0.0
@export var double_click_chance: float = 0.0

var count: int = 0

func get_cost() -> float:
	return base_cost * pow(cost_multiplier, count)
