module Unfezant.FFI.Application

import Unfezant.FFI.Dom
import Unfezant.FFI.Promise
import Unfezant.FFI.Container

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
