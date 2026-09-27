module Main

import Unfezant.FFI.Browser
import Unfezant.FFI.Pixi

main : IO ()
main = do
    body <- getDomBody
    consoleLog body
    let canvas = getApplicationCanvas app
    domBodyAppendChild body canvas
