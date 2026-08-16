extends Node2D

var solitaire_scene = load("res://solitaire/solitaire.tscn")

func _on_start_solitaire():
    
    get_tree().change_scene_to_packed(solitaire_scene)

func _on_settings():
    pass