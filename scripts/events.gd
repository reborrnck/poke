extends Node

## Global event bus for decoupled communication between systems.

signal show_dialogue(npc_name: String, text: String)
signal hide_dialogue()
signal request_scene_change(scene_path: String, spawn_point: String)
