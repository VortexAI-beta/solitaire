extends Node

var config = ConfigFile.new();

func set_default_config():
    var err = config.load("user://config.ini");

    if err != OK:
        config.set_value("card", "back_color", 0)
        config.set_value("game", "turn_style", 3)
        config.save("user://config.ini");

    var back_color = config.get_value("card", "back_color");
    if back_color == null:
        config.set_value("card", "back_color", 0)
    
    var turn_style = config.get_value("game", "turn_style");
    if turn_style == null:
        config.set_value("game", "turn_style", 3)
    
    config.save("user://config.ini");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    set_default_config()
