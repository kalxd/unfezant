module Unfezant.FFI.Pixi

import Unfezant.FFI.Browser

%default total

export
data Application : Type where

namespace Binding
    export
    %foreign "browser:support:new_application,pixi"
    newApplication : PrimIO Application

export
mkApplication : HasIO io => io Application
mkApplication = primIO $ Binding.newApplication

namespace Binding
    export
    %foreign "browser:lambda:(app) => app.canvas"
    getApplicationCanvas : Application -> DomCanvas

export
getApplicationCanvas : Application -> DomCanvas
getApplicationCanvas = Binding.getApplicationCanvas
