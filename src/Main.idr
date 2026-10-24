module Main

import Unfezant.Engine

initWindow : Promise ()
initWindow = do
    win <- domWindow
    body <- domBody
    app <- mkApplication
    let option : ApplicationOptions
        option = MkApplicationOptions (Just "#1099bb") win
    app.init option
    body.appendChild app.canvas

    texture <- loadTexture "https://pixijs.com/assets/bunny.png"
    let bunny = mkSprint texture
    app.stage.addChild bunny
    bunny.anchor.set 0.5 0.5

    bunny.setX $ app.screen.width / 2
    bunny.setY $ app.screen.height / 2

main : IO ()
main = execPromise initWindow
