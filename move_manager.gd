extends Node

class_name MoveManager

@export var waste: Pile
@export var deck: Pile

var undo_redo = UndoRedo.new()

func move_card_between_piles(card: Card, from_pile: Pile, to_pile: Pile, old_position: Vector2 = Vector2(0, 0)):
    undo_redo.create_action("move card (" + Card.Suits.keys()[card.suit] + "," + str(card.value) + ") from pile (" + Pile.PileType.keys()[from_pile.pile_type] + "," + str(from_pile.idx) + ") to pile (" + Pile.PileType.keys()[to_pile.pile_type] + "," + str(to_pile.idx) + ")")

    var should_flip_card = from_pile.should_flip_next_card(card)

    print(old_position)

    undo_redo.add_do_method(from_pile.remove_stack.bind(card));
    undo_redo.add_do_method(to_pile.add_stack.bind(card));

    if (from_pile.pile_type == Pile.PileType.Pile && should_flip_card):
        undo_redo.add_do_method(from_pile.flip_top_card)
        undo_redo.add_undo_method(from_pile.flip_top_card)

    undo_redo.add_undo_method(to_pile.remove_stack.bind(card))
    undo_redo.add_undo_method(from_pile.add_stack.bind(card))
    undo_redo.add_undo_property(card, 'position', old_position)

    undo_redo.commit_action()


func draw_from_deck():
    undo_redo.create_action("draw from deck")

    for card in waste.cards:
        var pos = card.position
        undo_redo.add_do_property(card, 'position', Vector2.ZERO)
        undo_redo.add_undo_property(card, 'position', pos)
 
    var cards: Array[Card] = deck.cards.slice(max(0,deck.cards.size()-3),  deck.cards.size());
    
    # needs to be registered in this card order, otherwise the scene tree will not be setup properly
    for card in cards: 
        undo_redo.add_undo_method(waste.remove_stack.bind(card))
        undo_redo.add_undo_method(deck.add_stack.bind(card))
        undo_redo.add_undo_method(card.flip);
    
    cards.reverse();

    for card in cards:
        undo_redo.add_do_method(card.flip);
        undo_redo.add_do_method(deck.remove_stack.bind(card))
        undo_redo.add_do_method(waste.add_stack.bind(card))


    for i in range(cards.size()):
        var card = cards[i]
        var pos = card.position
        if i == 0:
            undo_redo.add_do_property(card, 'position', Vector2(0, 0))
        else:
            undo_redo.add_do_property(card, 'position', Vector2(10, 0))
        undo_redo.add_undo_property(card, 'position', pos)
    undo_redo.commit_action()

func return_waste_to_deck():
    if (deck.cards.size() == 0):
        undo_redo.create_action("return waste to deck")
        for card in waste.cards:
            undo_redo.add_do_method(card.flip)
            undo_redo.add_undo_method(card.flip)

        for card in waste.cards:
            var pos = card.position
            undo_redo.add_undo_method(deck.remove_stack.bind(card))
            undo_redo.add_undo_method(waste.add_stack.bind(card))
            undo_redo.add_undo_property(card, 'position', pos)

        waste.cards.reverse()

        for card in waste.cards:
            undo_redo.add_do_method(waste.remove_stack.bind(card))
            undo_redo.add_do_method(deck.add_stack.bind(card))
        undo_redo.commit_action()

func undo():
    undo_redo.undo()

func redo():
    undo_redo.redo()