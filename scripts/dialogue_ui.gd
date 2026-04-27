extends CanvasLayer

@onready var _panel: Panel = $Panel
@onready var _name_label: Label = $Panel/MarginContainer/VBoxContainer/NameLabel
@onready var _text_label: Label = $Panel/MarginContainer/VBoxContainer/TextLabel
@onready var _continue_hint: Label = $Panel/MarginContainer/VBoxContainer/ContinueHint

var _active: bool = false
var _can_close: bool = false  # brief delay before allowing close


func _ready() -> void:
	Events.show_dialogue.connect(_show)
	Events.hide_dialogue.connect(_hide)
	_hide()
	layer = 100


func _input(event: InputEvent) -> void:
	if not _active or not _can_close:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		get_viewport().set_input_as_handled()
		_hide()


func _show(_npc_name: String, text: String) -> void:
	_name_label.text = _npc_name
	_text_label.text = text
	_panel.visible = true
	_active = true
	_can_close = false
	Events.toggle_player.emit(false)
	# Brief delay so the same key press doesn't close immediately
	await get_tree().create_timer(0.15).timeout
	_can_close = true


func _hide() -> void:
	_panel.visible = false
	_active = false
	_can_close = false
	Events.toggle_player.emit(true)
