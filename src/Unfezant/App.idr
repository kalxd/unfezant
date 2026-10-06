module Unfezant.App

import Control.App

%default total

export
interface GameEngine e where
    width : App {l} e Double

data PixiState : Type where
