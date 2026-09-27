module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

initValue : Promise Nat
initValue = pure 1

main : IO ()
main = do
    body <- getDomBody
    consoleLog body
    let p2 = do
        n <- initValue
        pure $ n + 2
    runPromise consoleLog p2
