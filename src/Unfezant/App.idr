module Unfezant.App

import Control.App
import Control.App.Console
import Unfezant.Engine

%default total

export
interface GameEngine e where
    width : App {l} e Double

data PixiState : Type where

f : (HasErr String es, State PixiState Int es) => App es ()
f = throw "failed"

g : Console es => App es ()
g = putStrLn "hello"

covering
main : IO ()
main = run g
