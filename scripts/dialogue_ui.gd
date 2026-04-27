extends CanvasLayer

## Simple dialogue box that appears at the bottom of the screen.

@onready var _panel: Panel = $Panel
@onready var _name_label: Label = $Panel/MarginContainer/VBoxContainer/NameLabel
@onready var _text_label: Label = $Panel/MarginContainer/VBoxContainer/TextLabel
@onready var _continue_hint: Label = $Panel/MarginContainer/VBoxContainer/ContinueHint

var _visible: bool = false


func _ready() -> void:
	Events.show_dialogue.connect(_show)
	Events.hide_dialogue.connect(_hide)
	_hide()
	layer = 100  # Always on top


func _input(event: InputEvent) -> void:
	if not _visible:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		_hide()


func _show(npc_name: String, text: String) -> void:
	_name_label.text = npc_name
	_text_label.text = text
	_panel.visible = true
	_visible = true
	get_tree().paused = true


func _hide() -> void:
	_panel.visible = false
	_visible = false
	get_tree().paused = false
