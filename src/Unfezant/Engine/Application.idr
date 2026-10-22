module Unfezant.Engine.Application

import Unfezant.Engine.JS
import Unfezant.Engine.Dom
import Unfezant.Engine.Promise
import Unfezant.Engine.Container
import Unfezant.Engine.Ticker
import Unfezant.Engine.Rectangle

import Control.Monad.State

export
data Application : Type where

%foreign "browser:support:new_application,pixi"
ffi_applicationNew : PrimIO Application

%foreign "browser:lambda:(app) => app.canvas"
ffi_applicationCanvas : Application -> DomCanvas

%foreign "browser:lambda:(app) => app.stage";
ffi_applicationStage : Application -> Container

%foreign "browser:lambda:(app) => app.ticker"
ffi_ticker : Application -> Ticker

export
mkApplication : HasIO io => io Application
mkApplication = primIO $ ffi_applicationNew

public export
record ApplicationOptions where
    constructor MkApplicationOptions
    backgroundColor: Maybe String
    resizeTo: DomWindow

ToJsObject ApplicationOptions where
    toJsObject option = obj $ do
        "backgroundColor" :=? option.backgroundColor
        "resizeTo" :=! option.resizeTo

%foreign "browser:support:init_application,pixi"
prim_applicationInit : Application -> JsObject -> Promise ()

export
(.init) : Application -> ApplicationOptions -> Promise ()
(.init) app options = do
    o <- toJsObject options
    prim_applicationInit app o

export
(.canvas) : Application -> DomCanvas
(.canvas) = ffi_applicationCanvas

%foreign "browser:lambda:(app) => app.screen"
ffi_screen : Application -> PrimIO Rectangle

%inline
export
(.screen) : HasIO io => Application -> io Rectangle
(.screen) = primIO . ffi_screen

export
(.stage) : Application -> Container
(.stage) = ffi_applicationStage

export
(.ticker) : Application -> Ticker
(.ticker) = ffi_ticker
