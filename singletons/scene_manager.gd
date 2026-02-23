extends Node


signal scene_changed
signal transition_started
signal transition_finished

@onready var tree := get_tree()
var current_scene_path: String = ""
var is_transitioning: bool = false

var _canvas_layer: CanvasLayer
var _color_rect: ColorRect

# simple change, no transition
func change_scene(newpath: String) -> void:
	if is_transitioning:
		return
	current_scene_path = newpath
	tree.change_scene_to_file(newpath)
	scene_changed.emit()
	
func change_scene_transition(newpath: String, duration_seconds: float = 0.5) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	transition_started.emit()
	
	# fade out
	var tween := create_tween()
	var overlay := _get_overlay()
	overlay.visible = true
	tween.tween_property(overlay, "color:a", 1.0, duration_seconds)
	await tween.finished
	
	tree.change_scene_to_file(newpath)
	current_scene_path = newpath
	scene_changed.emit()
	
	# wait frame to ensure new scene is ready
	await tree.process_frame
	
	# ..then fade in
	tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, duration_seconds)
	await tween.finished
	overlay.visible = false
	
	is_transitioning = false
	transition_finished.emit()

func reload_current_scene() -> void:
	tree.reload_current_scene()


func _ready() -> void:
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 100
	add_child(_canvas_layer)

	_color_rect = ColorRect.new()
	_color_rect.color = Color(0, 0, 0, 0)
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_color_rect.visible = false
	_canvas_layer.add_child(_color_rect)

func _get_overlay() -> ColorRect:
	return _color_rect