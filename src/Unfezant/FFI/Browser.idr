module Unfezant.FFI.Browser

%default total

public export
record DomCanvas where
    constructor MkDomCanvas
    ptr : AnyPtr

export
data DomBody : Type where

namespace Binding
    export
    %foreign "browser:lambda:() => document.body"
    getDomBody : PrimIO DomBody

export
getDomBody : HasIO io => io DomBody
getDomBody = primIO $ Binding.getDomBody

namespace Binding
    export
    %foreign "browser:lambda:(body, canvas) => body.appendChild(canvas)"
    domBodyAppendChild : DomBody -> AnyPtr -> PrimIO ()

export
domBodyAppendChild : HasIO io => DomBody -> DomCanvas -> io ()
domBodyAppendChild body (MkDomCanvas x) = primIO $ Binding.domBodyAppendChild body x

namespace Binding
    export
    %foreign "browser:lambda:(a, args) => console.log(args)"
    consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . Binding.consoleLog
