extends Node2D

var solitaire_scene = preload("res://solitaire/solitaire.tscn")
var settings_scene = preload("res://screens/settings_screen.tscn")

func _on_start_solitaire():
    
    get_tree().change_scene_to_packed(solitaire_scene)

func _on_settings():
    get_tree().change_scene_to_packed(settings_scene)