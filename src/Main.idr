module Main

import Unfezant.Engine
import Control.Monad.ST

initWindow : Promise ()
initWindow = do
    win <- domWindow
    body <- domBody
    app <- mkApplication
    app.init win
    body.appendChild app.canvas

    app.stage.addChild $ newGraphicsWith $ \ref => do
        setRect (10.0, 10.0, 200.0, 200.0) ref
        setFill "0x0000FF" ref
    app.stage.addChild $ newGraphicsWith $ \ref => do
        setRect (300, 10, 200, 200) ref
        setFill "red" ref

    app.ticker.add $ \_ => pure ()

main : IO ()
main = execPromise initWindow
