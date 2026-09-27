module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

main : IO ()
main = do
    body <- getDomBody
    consoleLog body
    let p1 = the (PromiseT Void IO Nat) $ mkPromise $ pure 1
    let p2 = thenPromise p1 $ \v => mkPromise $ pure $ v + 1
    consoleLog p2
    runPromise p2 consoleLog
    -- let canvas = getApplicationCanvas app
    -- domBodyAppendChild body canvas
