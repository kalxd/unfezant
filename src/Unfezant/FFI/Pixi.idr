module Unfezant.FFI.Pixi

import Unfezant.FFI.Browser

%default total

export
record Application where
    constructor MkApplication
    ptr : AnyPtr

namespace Binding
    export
    %foreign "browser:support:new_application,pixi"
    newApplication : PrimIO AnyPtr

export
mkApplication : HasIO io => io Application
mkApplication = MkApplication <$> (primIO $ Binding.newApplication)

namespace Binding
    export
    %foreign "browser:lambda:(app) => app.canvas"
    getApplicationCanvas : AnyPtr -> AnyPtr

export
getApplicationCanvas : Application -> DomCanvas
getApplicationCanvas (MkApplication ptr) = MkDomCanvas $ Binding.getApplicationCanvas ptr
