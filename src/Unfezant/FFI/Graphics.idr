module Unfezant.FFI.Graphics

import Control.Monad.ST

export
data Graphics : Type where

%foreign "browser:support:new_graphics,pixi"
ffi_graphicsNew : PrimIO Graphics

%foreign "browser:lambda:(g, x, y, w, h) => g.rect(x, y, w, h)"
ffi_graphicsSetRect : Graphics -> Double -> Double -> Double -> Double -> PrimIO Graphics

export
data GraphicsRef : (s : Type) -> Type where
    MkGraphicsRef : STRef s Graphics -> GraphicsRef s

export
newGraphicsRef : ST s (GraphicsRef s)
newGraphicsRef = MkGraphicsRef <$> (newSTRef $ unsafePerformIO $ primIO ffi_graphicsNew)
