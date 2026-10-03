module Unfezant.Engine.Application

import Unfezant.Engine.Dom
import Unfezant.Engine.Promise
import Unfezant.Engine.Container
import Unfezant.Engine.Ticker

export
data Application : Type where

%foreign "browser:support:new_application,pixi"
ffi_applicationNew : PrimIO Application

%foreign "browser:support:init_application,pixi"
ffi_applicationInit : Application -> DomWindow -> Promise ()

%foreign "browser:lambda:(app) => app.canvas"
ffi_applicationCanvas : Application -> DomCanvas

%foreign "browser:lambda:(app) => app.stage";
ffi_applicationStage : Application -> Container

%foreign "browser:lambda:(app) => app.ticker"
ffi_ticker : Application -> Ticker

export
mkApplication : HasIO io => io Application
mkApplication = primIO $ ffi_applicationNew

export
(.init) : Application -> DomWindow -> Promise ()
(.init) = ffi_applicationInit

export
(.canvas) : Application -> DomCanvas
(.canvas) = ffi_applicationCanvas

export
(.stage) : Application -> Container
(.stage) = ffi_applicationStage

export
(.ticker) : Application -> Ticker
(.ticker) = ffi_ticker
