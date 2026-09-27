module Unfezant.FFI.Pixi

import Unfezant.FFI.Browser

%default total

export
data Application : Type where

namespace Binding
    export
    %foreign "browser:support:new_application,pixi"
    ffiApplicationNew : PrimIO Application

    export
    %foreign "browser:support:init_application,pixi"
    ffiApplicationInit : Application -> DomWindow -> Promise ()

export
mkApplication : HasIO io => io Application
mkApplication = primIO $ Binding.ffiApplicationNew

export
initApplication : Application -> DomWindow -> Promise()
initApplication = Binding.ffiApplicationInit

namespace Binding
    export
    %foreign "browser:lambda:(app) => app.canvas"
    ffiApplicationCanvas : Application -> DomCanvas

export
getApplicationCanvas : Application -> DomCanvas
getApplicationCanvas = Binding.ffiApplicationCanvas
