extends CanvasLayer

@onready var _panel: Panel = $Panel
@onready var _name_label: Label = $Panel/MarginContainer/VBoxContainer/NameLabel
@onready var _text_label: Label = $Panel/MarginContainer/VBoxContainer/TextLabel
@onready var _continue_hint: Label = $Panel/MarginContainer/VBoxContainer/ContinueHint

var _active: bool = false
var _lines: Array[String] = []
var _index: int = 0


func _ready() -> void:
	Events.show_dialogue.connect(_show)
	_hide()
	layer = 100


func _input(event: InputEvent) -> void:
	if not _active:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		get_viewport().set_input_as_handled()
		_advance()


func _show(_npc_name: String, lines: Array[String]) -> void:
	_name_label.text = _npc_name
	_lines = lines
	_index = 0
	_panel.visible = true
	_active = true
	Events.dialogue_active = true
	Events.toggle_player.emit(false)
	_show_current_line()


func _show_current_line() -> void:
	if _index < _lines.size():
		_text_label.text = _lines[_index]
		_continue_hint.visible = true
	else:
		_hide()


func _advance() -> void:
	_index += 1
	_show_current_line()


func _hide() -> void:
	_panel.visible = false
	_active = false
	_lines.clear()
	_index = 0
	Events.dialogue_active = false
	Events.toggle_player.emit(true)
