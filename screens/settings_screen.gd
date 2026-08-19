extends Node2D

var start_screen_path = "res://screens/start_screen.tscn"
var config = ConfigFile.new()

@onready var back_sprite: Sprite2D = $"./BackSprite"

func _ready() -> void:
    var err = config.load("user://config.ini")

    if err != OK:
        return

    var selected_back_sprite = config.get_value("card", "back_color", 0)

    var back_sprite_select: OptionButton = $"./OptionsContainer/BackColorSelect"
    back_sprite_select.select(selected_back_sprite)
    back_sprite.frame = selected_back_sprite

    var selected_turn_style = config.get_value("game", "turn_style", 0);

    var turn_style_select: OptionButton = $"./OptionsContainer/TurnStyleSelect"
    turn_style_select.select(selected_turn_style)

func _on_color_change(index: int):
    back_sprite.frame = index
    config.set_value("card", "back_color", index)
    config.save("user://config.ini")

func _on_turn_style_change(index: int):
    config.set_value("game", "turn_style", Constants.turn_id_to_num[index])
    config.save("user://config.ini")

func _on_return():
    print('return')
    get_tree().change_scene_to_file(start_screen_path)