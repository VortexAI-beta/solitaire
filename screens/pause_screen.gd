extends CanvasLayer

var start_screen_scene = preload("res://screens/start_screen.tscn")
var solitaire_scene = preload("res://solitaire/solitaire.tscn")

func _on_resume():
    get_tree().paused = false;
    self.queue_free()

func _on_restart():
    get_tree().paused = false;
    get_tree().reload_current_scene()
    self.queue_free()

func _on_return():
    get_tree().paused = false;
    get_tree().change_scene_to_packed(start_screen_scene)
    self.queue_free()