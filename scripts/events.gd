extends Node

signal show_dialogue(npc_name: String, lines: Array[String])
signal toggle_player(active: bool)
signal request_scene_change(scene_path: String, spawn_point: String)
