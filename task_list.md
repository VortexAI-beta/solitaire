Task List
  - [x] Make sure the foundation piles function properly.
  - [x] Make sure card stacking works properly WIP -> Something goes wrong with add_stack. parents not set properly
    - [x] When on the foundation, they should stack lowest to highest an only with the same color.
    - [x] When on a regular pile, they should stack highest to lower, only on different colors.
    - [x] When in the deck/foundation, they should never stack.
    - [x] Cards cannot be stacked on top of face down cards
  - [x] fix flip back of deck
  - [x] card selecting should be done based on the z-index if multiple cards are selected
  - [x] Implement deck draging functionality
    - [x] Not possible to get any card from the deck that is not a part of the waste plile
    - [x] Only the top card of the wate pile is grabable.
  - [] Implement win condition
  - [x] Implement undo/redo
  - [] implement start screen
  - [] add back of card graphics
  - [] add background graphics
  - [] add small suit indicate on top of card

Bugs:
  - [x] z-index for waste-pile -> Increased drag to 1000 and now it works. Not sure what the actual problem was tho.

QOL:
  - [] Ensure that double klic pushes to foundational pile if possible
  - [x] Undo Redo
  - [] Checker for feasible solution