module Unfezant.FFI.Container

export
data Container : Type where

%foreign "browser:lambda:(a, container, child) => container.addChild(child)"
ffi_containerAddChild : Container -> a -> PrimIO ()

export
(.addChild) : HasIO io => Container -> a -> io ()
(.addChild) container child = primIO $ ffi_containerAddChild container child
