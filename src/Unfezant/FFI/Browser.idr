module Unfezant.FFI.Browser

%default total

public export
record DomCanvas where
    constructor MkDomCanvas
    ptr : AnyPtr

export
record DomBody where
    constructor MkDomBody
    ptr : AnyPtr

namespace Binding
    export
    %foreign "browser:lambda:() => document.body"
    getDomBody : PrimIO AnyPtr

export
getDomBody : HasIO io => io DomBody
getDomBody = MkDomBody <$> (primIO $ Binding.getDomBody)

namespace Binding
    export
    %foreign "browser:lambda:(body, canvas) => body.appendChild(canvas)"
    domBodyAppendChild : AnyPtr -> AnyPtr -> PrimIO ()

export
domBodyAppendChild : HasIO io => DomBody -> DomCanvas -> io ()
domBodyAppendChild (MkDomBody ptr) (MkDomCanvas x) = primIO $ Binding.domBodyAppendChild ptr x

namespace Binding
    export
    %foreign "browser:lambda:console.log"
    consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . Binding.consoleLog
