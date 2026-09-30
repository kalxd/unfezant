module Unfezant.FFI.Dom

%default total

export
data DomCanvas : Type where

export
data DomBody : Type where

export
data DomWindow : Type where

%foreign "browser:lambda:() => window"
ffi_domWindow : PrimIO DomWindow

%foreign "browser:lambda:() => document.body"
ffi_domBody : PrimIO DomBody

%foreign "browser:lambda:(body, canvas) => body.appendChild(canvas)"
ffi_appendChild : DomBody -> DomCanvas -> PrimIO ()

%inline
export
domWindow : HasIO io => io DomWindow
domWindow = primIO $ ffi_domWindow

%inline
export
domBody : HasIO io => io DomBody
domBody = primIO $ ffi_domBody

export
%inline
(.appendChild) : HasIO io => DomBody -> DomCanvas -> io ()
(.appendChild) body = primIO . ffi_appendChild body
