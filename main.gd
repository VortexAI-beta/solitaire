extends Node2D

var card_scene = preload("res://card.tscn")
var pile_scene = preload("res://pile.tscn")

var card_width = 30
var card_length = 40
var buffer = 10

# Used for draggin cards
var dragging_card: Card = null
var drag_offset: Vector2 = Vector2.ZERO
var original_positon: Vector2 = Vector2.ZERO
var original_parent: Node = null 
var original_pile_index: int = -1;
var original_pile_location: int = -1;

# Where the aces are stored
@export var piles: Array[Pile] = []
@export var foundations: Array[Pile] = []
@export var deck: Pile;
@export var waste: Pile;

func constructDeck():
    var cards: Array[Card] = [] 
    for i in range(1, 14):
        for suit in Card.Suits.values():
            var card: Card = card_scene.instantiate();
            card.initialize(suit , i);
            # card.initialize(suit / 2, i%3 +1);
            card.card_clicked.connect(on_card_clicked)
            card.card_released.connect(on_card_released)
            cards.append(card)
            
    cards.shuffle()

    for card in cards:
        deck.add_stack(card);

func shuffle_and_deal():    
    ## draw cards from the deck and add them to piles
    for i in range(7):
        var pile = piles[i]
        
        for j in range(i+1):
            var card = deck.cards.pop_back();
            pile.add_stack(card)
            if i == j:
                card.flip();

func configure_piles():
    for i in range(piles.size()):
        piles[i].idx = i;
    
    for i in range(4):
        foundations[i].idx = i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # ensure that if multiple cards a clicked, only the top one will be used for draggin.
    get_viewport().physics_object_picking_first_only = true
    get_viewport().physics_object_picking_sort = true
    constructDeck()
    configure_piles()
    shuffle_and_deal()

func on_card_clicked(card: Card, event: InputEventMouseButton):
    if card.location == Pile.PileType.Deck:
        if card == deck.cards.back():
            get_viewport().set_input_as_handled()
            draw_from_deck()
    elif card.location == Pile.PileType.Waste:
        if(card == waste.cards.back()):
            start_drag(card)
    elif card.location == Pile.PileType.Pile:
        start_drag(card)
    elif card.location == Pile.PileType.Foundation:
        start_drag(card)

func start_drag(card: Card):
    if !card.face_up:
        return
    
    dragging_card = card
    original_positon = card.position
    original_parent = card.get_parent()
    drag_offset = card.global_position - get_global_mouse_position()

    var tween = create_tween();
    tween.tween_property(card, 'scale', Vector2(1.2,1.2), Constants.card_consts.tween_speed)
    
    var global_position = card.global_position
    card.get_parent().remove_child(card)
    add_child(card) # add to main aka top of hierarchy
    card.global_position= global_position
    card.z_index=100

func draw_from_deck():
    var position = waste.position
    
    for card in waste.cards:
        card.position = Vector2(0,0)
 
    var cards: Array[Card] = deck.cards.slice(max(0,deck.cards.size()-3),  deck.cards.size());
    cards.reverse();
    for card in cards:
        card.flip();
        deck.remove_stack(card)
        waste.add_stack(card)

    for i in range(cards.size()):
        var card = cards[i]
        if i == 0:
            card.position = Vector2(0, 0)
        else:
            card.position = Vector2(10, 0)

func get_card_pile(card: Card):
    if card.location == Pile.PileType.Deck:
        return deck
    elif card.location == Pile.PileType.Waste:
        return waste
    elif card.location == Pile.PileType.Pile:
        return piles[card.pile_idx]
    elif card.location == Pile.PileType.Foundation:
        return foundations[card.pile_idx]

func on_card_released(card: Card, _event: InputEventMouseButton):
    # seems to be a bug here. I think somehow the tree is not properly maintained when a sub tree gets moved but only to a previous stack. Not sure why yet.
    if dragging_card:
        var tween = create_tween();
        tween.tween_property(dragging_card, 'scale', Vector2(1.1,1.1), Constants.card_consts.tween_speed)

        var areas = dragging_card.get_overlapping_areas()

        # var cards = areas.filter(func (x): return x is Card) as Array[Card]
        # var overlapping_piles = areas.filter(func (x): return x is Pile) as Array[Pile]

        var cards: Array[Card] = []
        var overlapping_piles: Array[Pile]= []

        cards.assign(areas.filter(func (x): return x is Card))
        overlapping_piles.assign(areas.filter(func (x): return x is Pile))

        # cards have priority over piles
        if cards.size() > 0:
            if stack_on_card(cards):
                return

        if overlapping_piles.size() > 0:
            if stack_on_pile(overlapping_piles):
                return
        
        dragging_card.position = original_positon
        dragging_card.get_parent().remove_child(dragging_card)
        original_parent.add_child(dragging_card)
        dragging_card.z_index = 1;
        dragging_card = null

# When a card is stacked on top a another card, it must satisfy the following requirements:
# 1. if the card on which the dragging card is placed is on the` deck or the waste, don't place it
# 2. if the card will be placed on a pile, the top card should be this cards value + 1 and a different colored (red,blac) suit
# 3. if the card will be placed on a foundation pile, the top card should be the value-1 and it should be the same suit  
# Returns true on succes, fales otherwise 
func stack_on_card(cards: Array[Card]):
    for overlapping_card in cards:
        if overlapping_card.pile_idx == dragging_card.pile_idx && overlapping_card.location == dragging_card.location:
            continue;

        var current_pile = get_card_pile(dragging_card)
        var new_pile = get_card_pile(overlapping_card)

        var pile_type = new_pile.pile_type

        var top_card = new_pile.cards.back();
        if top_card != overlapping_card:
            continue

        var add_card_to_pile = func():
            current_pile.remove_stack(dragging_card)
            new_pile.add_stack(dragging_card)
            dragging_card = null

        match pile_type:
            Pile.PileType.Deck:
                continue
            Pile.PileType.Waste:
                continue
            Pile.PileType.Foundation:
                if top_card.suit == dragging_card.suit && top_card.value == dragging_card.value - 1:
                    add_card_to_pile.call();
                    return true;
            Pile.PileType.Pile:
                var not_has_same_color = Card.suit_to_color[top_card.suit] != Card.suit_to_color[dragging_card.suit]
                var has_lower_value = top_card.value == dragging_card.value + 1
                if not_has_same_color && has_lower_value:
                    add_card_to_pile.call();
                    return true;

    return false

# for stacking on piles directly, we must adhere to the following rules.
# 1. never place on the deck or waste piles
# 2. if we place the card on a pile, it must be a king (value 13)
# 3. if we place a card on a foundation, it must be an ace (value 1)
# returns true on succes, false otherwise
func stack_on_pile(overlapping_piles: Array[Pile]):
    for pile in overlapping_piles:
        if pile.idx == dragging_card.pile_idx && pile.pile_type == get_card_pile(dragging_card).pile_type:
            continue;
        if !pile.cards.is_empty():
            continue

        var add_card_to_pile = func():
            var current_pile = get_card_pile(dragging_card)
            current_pile.remove_stack(dragging_card)
            pile.add_stack(dragging_card)
            dragging_card = null
            return
        
        match pile.pile_type:
            Pile.PileType.Deck:
                continue
            Pile.PileType.Waste:
                continue
            Pile.PileType.Foundation:
                if dragging_card.value == 1:
                    add_card_to_pile.call()
                    return true
            Pile.PileType.Pile:
                if dragging_card.value == 13:
                    add_card_to_pile.call()
                    return true

    return false

# Checks if the picked card and target cards have different colors.
# aka if picked card is red, it returns true if target card is black.
func has_different_color(picked_card: Card, target_card: Card): 
    if picked_card.suit == Card.Suits.Heart or picked_card.suit == Card.Suits.Diamond:
        return target_card.suit == Card.Suits.Club or target_card.suit == Card.Suits.Spade
    else:
        return target_card.suit == Card.Suits.Heart or target_card.suit == Card.Suits.Diamond

func find_card_on_foundation(card: Card):
    # will come back to this

    return -1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if dragging_card:
        dragging_card.global_position = get_global_mouse_position() + drag_offset

# turn the waste pile back onto the deck
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            if (deck.cards.size() == 0):
                for card in waste.cards:
                    card.flip();
                waste.cards.reverse()
                for card in waste.cards:
                    waste.remove_stack(card)
                    deck.add_stack(card)

#Debug
func _print_card(card: Card):
    print('card suit: ', _suit_to_string(card.suit), ' value: ', card.value)

func _suit_to_string(suit: Card.Suits):
    if suit == Card.Suits.Heart:
        return 'Heart'
    elif suit == Card.Suits.Spade:
        return 'Spade'
    elif suit == Card.Suits.Club:
        return 'Club'
    elif suit == Card.Suits.Diamond:
        return 'Diamond'
    else:
        return 'Unknown'
