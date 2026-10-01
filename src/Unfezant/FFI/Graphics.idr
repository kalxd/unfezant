module Unfezant.FFI.Graphics

import Control.Monad.ST

export
data Graphics : Type where

%foreign "browser:support:new_graphics,pixi"
ffi_graphicsNew : PrimIO Graphics

%foreign "browser:lambda:(g, x, y, w, h) => g.rect(x, y, w, h)"
ffi_graphicsSetRect : Graphics -> Double -> Double -> Double -> Double -> PrimIO Graphics

%foreign "browser:lambda:(g, color) => g.fill(color)"
ffi_graphicsSetFill : Graphics -> String -> PrimIO Graphics

export
newGraphicsRef : ST s (STRef s Graphics)
newGraphicsRef = newSTRef $ unsafePerformIO $ primIO ffi_graphicsNew

export
setRect : (Double, Double, Double, Double) -> STRef s Graphics -> ST s ()
setRect (x, y, w, h) ref = modifySTRef ref g
    where g : Graphics -> Graphics
          g graph = unsafePerformIO $ primIO $ ffi_graphicsSetRect graph x y w h

export
setFill : String -> STRef s Graphics -> ST s ()
setFill color ref = modifySTRef ref k
    where k : Graphics -> Graphics
          k graph = unsafePerformIO $ primIO $ ffi_graphicsSetFill graph color

export
newGraphicsWith : (forall s. STRef s Graphics -> ST s ()) -> Graphics
newGraphicsWith f = runST $ do
    ref <- newGraphicsRef
    f ref
    readSTRef ref
