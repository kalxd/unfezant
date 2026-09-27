module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

initWindow : Promise ()
initWindow = do
    win <- liftIO getDomWindow
    body <- liftIO getDomBody
    app <- liftIO mkApplication
    initApplication app win
    liftIO $ domBodyAppendChild body $ getApplicationCanvas app

main : IO ()
main = runPromise (\_ => pure ()) initWindow
