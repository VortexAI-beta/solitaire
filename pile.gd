class_name Pile
extends Area2D

var idx: int = -1;
var cards: Array[Card] = []

enum PileType { Deck, Waste, Foundation, Pile}

@export var marker: Marker2D; 
@export var pile_type: PileType;

func add_stack(incoming_card: Card):
    var is_empty_pile = cards.is_empty()
    
    if incoming_card.get_parent():
        print("removing child")
        incoming_card.get_parent().remove_child(incoming_card)
        
    if is_empty_pile:
        marker.add_child(incoming_card)
        incoming_card.position = Vector2.ZERO
    else:
        print(cards.back())
        var top_card = cards.back()
        top_card.add_child(incoming_card)
        match pile_type:
            PileType.Deck:
                incoming_card.position = Vector2(0, 0)
            PileType.Waste:
                incoming_card.position = Vector2(0, 0)
            PileType.Foundation:
                incoming_card.position = Vector2(0, 0)
            PileType.Pile:
                incoming_card.position = Vector2(0, 15)
    
    # print("added new card to tree")
    # We need to add the card and all its nested children to our array
    var to_append: Array[Card] = [incoming_card]
    update_children_recursively(incoming_card, to_append)

    # print("found all cards to append to cards")

    for c in to_append:
        c.location = pile_type
        c.pile_idx = idx
        c.z_index = cards.size()
        cards.append(c)
    print("updated all card data")

func update_children_recursively(card: Card, to_append: Array[Card]):
    var current = card
    var card_child = find_card_child(card)
    if card_child:
        to_append.append(card_child)
        update_children_recursively(card_child, to_append)

func find_card_child(card: Card):
    var children = card.get_children();
    var cards = [];

    for child in children:
        if child is Card:
            cards.append(child);

    if cards.size() > 1:
        push_error("too many cards as children")
    
    if cards.size() == 1:
        return cards[0]
    else:
        return null


func remove_stack(starting_card: Card):
    var start_idx = cards.find(starting_card)
    if start_idx == -1: return
    
    # Remove the sub-stack from the array
    cards = cards.slice(0, start_idx)
    
    # Ensure the new top card is face up (only flip if it's face down)
    if not cards.is_empty() && pile_type == PileType.Pile:
        var top_card = cards.back()
        if not top_card.face_up:
            top_card.flip()