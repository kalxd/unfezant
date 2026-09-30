module Main

import Unfezant.FFI

initWindow : Promise ()
initWindow = do
    win <- domWindow
    body <- domBody
    app <- mkApplication
    app.init win
    body.appendChild app.canvas
    g <- mkGraphics
    _ <- setRect (10.0, 10.0, 200.0, 200.0) g
    _ <- setFill "0x00FFFF" g
    app.stage.addChild g
    -- addTicker (\ticker => consoleLog ticker.deltaTime) app

main : IO ()
main = runPromise (\_ => pure ()) initWindow
