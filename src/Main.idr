module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

initWindow : Promise ()
initWindow = do
    win <- getDomWindow
    body <- getDomBody
    app <- mkApplication
    initApplication app win
    domBodyAppendChild body $ getApplicationCanvas app

main : IO ()
main = runPromise (\_ => pure ()) initWindow
