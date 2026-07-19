class_name Card 
extends Area2D

enum Suits { Spade, Heart, Club, Diamond}
enum SuitColors { Red, Black }

static var suit_to_color = {
    Suits.Spade: SuitColors.Black,
    Suits.Club: SuitColors.Black,
    Suits.Heart: SuitColors.Red,
    Suits.Diamond: SuitColors.Red,
}

var suit: Suits = Suits.Heart
var value: int # 1-13
var face_up: bool = false;
var location: Pile.PileType = Pile.PileType.Deck;
var pile_idx: int = -1;

signal card_clicked(card_ref, event);
signal card_released(card_ref, event);

func setup(_suit: Suits, _value: int):
    suit = _suit
    value = _value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:    
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func updateSprite():
    $front.frame = (13 * suit) + value - 1
    $front.visible = face_up;
    $back_temp.visible = !face_up;

func initialize(_suit: Suits, _value: int):
    suit = _suit
    value = _value
    
    updateSprite()

func flip():
    face_up = !face_up;
    updateSprite();


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            card_clicked.emit(self, event);
            #flip();
        if !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            card_released.emit(self, event);