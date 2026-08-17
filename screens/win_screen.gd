extends CanvasLayer

var start_scene_path = "res://screens/pause_screen.tscn"
var solitarie_scene_path = "res://solitaire/solitaire.tscn"

func _on_restart():
    get_tree().change_scene_to_file(solitarie_scene_path)
    self.queue_free()

func _on_return():
    get_tree().change_scene_to_file(start_scene_path)
    self.queue_free()