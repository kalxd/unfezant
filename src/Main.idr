module Main

import Unfezant.Engine

initRes : List (String, String)
initRes = [ ("background", "https://pixijs.com/assets/tutorials/fish-pond/pond_background.jpg")
          , ("fish1", "https://pixijs.com/assets/tutorials/fish-pond/fish1.png")
          , ("fish2", "https://pixijs.com/assets/tutorials/fish-pond/fish2.png")
          , ("fish3", "https://pixijs.com/assets/tutorials/fish-pond/fish3.png")
          , ("fish4", "https://pixijs.com/assets/tutorials/fish-pond/fish4.png")
          , ("fish5", "https://pixijs.com/assets/tutorials/fish-pond/fish5.png")
          , ("overlay", "https://pixijs.com/assets/tutorials/fish-pond/wave_overlay.png")
          , ("displacemen", "https://pixijs.com/assets/tutorials/fish-pond/displacement_map.png")
          ]

initWindow : Promise ()
initWindow = do
    win <- domWindow
    body <- domBody
    app <- mkApplication
    let option : ApplicationOptions
        option = MkApplicationOptions (Just "#1099bb") win
    app.init option
    body.appendChild app.canvas

    _ <- for initRes loadTexture
    pure ()

main : IO ()
main = execPromise initWindow
