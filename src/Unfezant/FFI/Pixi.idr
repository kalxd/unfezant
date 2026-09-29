module Unfezant.FFI.Pixi

import Unfezant.FFI.Browser

%default total

export
data Application : Type where

export
data Ticker : Type where

export
data Graphics : Type where

export
data Container : Type where

%foreign "browser:support:new_application,pixi"
ffi_applicationNew : PrimIO Application

%foreign "browser:support:init_application,pixi"
ffi_applicationInit : Application -> DomWindow -> Promise ()

export
mkApplication : HasIO io => io Application
mkApplication = primIO $ ffi_applicationNew

export
initApplication : Application -> DomWindow -> Promise ()
initApplication = ffi_applicationInit

%foreign "browser:lambda:(app) => app.canvas"
ffi_applicationCanvas : Application -> DomCanvas

%foreign "browser:support:application_add_ticker,pixi"
ffi_applicationAddTicker : (Ticker -> PrimIO ()) -> Application -> PrimIO ()

%foreign "browser:lambda:(app) => app.stage";
ffi_applicationStage : Application -> Container

export
(.canvas) : Application -> DomCanvas
(.canvas) = ffi_applicationCanvas

export
(.stage) : Application -> Container
(.stage) = ffi_applicationStage

%foreign "browser:lambda:(a, container, child) => container.addChild(child)"
ffi_containerAddChild : Container -> a -> PrimIO ()

export
(.addChild) : HasIO io => Container -> a -> io ()
(.addChild) container = primIO . ffi_containerAddChild container

export
addTicker : HasIO io => (Ticker -> IO ()) -> Application -> io ()
addTicker f = primIO . ffi_applicationAddTicker g
    where g : Ticker -> PrimIO ()
          g ticker = toPrim $ f ticker

%foreign "browser:lambda:(ticker) => ticker.deltaTime"
ffi_TickerDeltaTime : Ticker -> Double

export
(.deltaTime) : Ticker -> Double
(.deltaTime) = ffi_TickerDeltaTime

%foreign "browser:support:new_graphics,pixi"
ffi_newGraphics : PrimIO Graphics

%foreign "browser:lambda:(g, x, y, w, h) => g.rect(x, y, w, h)"
ffi_graphicsSetRect : Graphics -> Double -> Double -> Double -> Double -> PrimIO Graphics

%foreign "browser:lambda:(g, color) => g.fill(color)"
ffi_graphicsSetFill : Graphics -> String -> PrimIO Graphics

export
mkGraphics : HasIO io => io Graphics
mkGraphics = primIO $ ffi_newGraphics

export
setRect : HasIO io => (Double, Double, Double, Double) -> Graphics -> io Graphics
setRect (x, y, w, h) g = primIO $ ffi_graphicsSetRect g x y w h

export
setFill : HasIO io => String -> Graphics -> io Graphics
setFill color g = primIO $ ffi_graphicsSetFill g color
