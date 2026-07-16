Task List
  - [x] Make sure the foundation piles function properly.
  - [x] Make sure card stacking works properly WIP -> Something goes wrong with add_stack. parents not set properly
    - [x] When on the foundation, they should stack lowest to highest an only with the same color.
    - [x] When on a regular pile, they should stack highest to lower, only on different colors.
    - [x] When in the deck/foundation, they should never stack.
    - [x] Cards cannot be stacked on top of face down cards
  - [x] fix flip back of deck
  - [] card selecting should be done based on the z-index if multiple cards are selected
  - [] Implement deck draging functionality
    - [] Not possible to get any card from the deck that is not a part of the waste plile
    - [] Only the top card of the wate pile is grabable.
  - [] Implement win condition
  - [] Implement undo/redo
  - [] implement start screen
  - [] add back of card graphics
  - [] add background graphics

Bugs:
  - [] z-index for waste-pile

QOL:
  - [] Ensure that double klic pushes to foundational pile if possible
  - [] Undo Redo
  - [] Checker for feasible solution