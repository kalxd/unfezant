module Unfezant.Engine.Rectangle

export
data Rectangle : Type where

%foreign "browser:lambda:(r) => r.width"
ffi_width : Rectangle -> Double

%inline
export
(.width) : Rectangle -> Double
(.width) = ffi_width

%foreign "browser:lambda:(r) => r.height"
ffi_height : Rectangle -> Double

%inline
export
(.height) : Rectangle -> Double
(.height) = ffi_height

%foreign "browser:lambda(r) => r.x"
ffi_x : Rectangle -> Double

%inline
export
(.x) : Rectangle -> Double
(.x) = ffi_x

%foreign "browser:lambda:(r) => r.y"
ffi_y : Rectangle -> Double

%inline
export
(.y) : Rectangle -> Double
(.y) = ffi_y
