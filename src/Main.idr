module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

main : IO ()
main = do
    body <- getDomBody
    app <- mkApplication
    let canvas = getApplicationCanvas app
    domBodyAppendChild body canvas
