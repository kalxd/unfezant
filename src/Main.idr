module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

main : IO ()
main = do
    body <- getDomBody
    consoleLog body
    let p1 = mkPromise $ pure 1
    let p2 = thenPromise (\a => mkPromise $ pure $ a + 2) p1
    consoleLog p1
    consoleLog p2
    runPromise consoleLog p2
