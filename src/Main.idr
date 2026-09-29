module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

initWindow : Promise ()
initWindow = do
    win <- getDomWindow
    body <- getDomBody
    app <- mkApplication
    initApplication app win
    body.appendChild app.canvas
    addTicker (\ticker => consoleLog $ ticker.deltaTime) app

main : IO ()
main = runPromise (\_ => pure ()) initWindow
