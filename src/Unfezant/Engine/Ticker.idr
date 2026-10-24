module Unfezant.Engine.Ticker

export
data Ticker : Type where

%foreign "browser:lambda:(f, ticker) => ticker.add(t => f(t)())"
prim_add : (Ticker -> PrimIO ()) -> Ticker -> PrimIO ()

export
(.add) : HasIO io => Ticker -> (Ticker -> IO ()) -> io ()
(.add) ticker f = primIO $ prim_add g ticker
    where g : Ticker -> PrimIO ()
          g t = toPrim $ f t

%foreign "browser:lambda:(ticker) => ticker.deltaTime"
prim__deltaTime : Ticker -> Double

export
(.deltaTime) : Ticker -> Double
(.deltaTime) = prim__deltaTime
