module Unfezant.Engine.ObservablePoint

export
data ObservablePoint : Type where

%foreign "browser:lambda:(point, a, b) => point.set(a, b)"
prim_setPoint : ObservablePoint -> Double -> Double -> PrimIO ()

export
(.set) : HasIO io => ObservablePoint -> Double -> Double -> io ()
(.set) point x y = primIO $ prim_setPoint point x y
