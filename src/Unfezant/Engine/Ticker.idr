module Unfezant.Engine.Ticker

export
data Ticker : Type where

%foreign "browser:lambda:(f, ticker) => ticker.add(t => f(t)())"
ffi_add : (Ticker -> PrimIO ()) -> Ticker -> PrimIO ()

export
(.add) : HasIO io => Ticker -> (Ticker -> IO ()) -> io ()
(.add) ticker f = primIO $ ffi_add g ticker
    where g : Ticker -> PrimIO ()
          g t = toPrim $ f t
