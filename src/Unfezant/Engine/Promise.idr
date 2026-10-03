module Unfezant.Engine.Promise

%default total

export
data Promise : Type -> Type where

%foreign "browser:lambda:(a, f) => new Promise(ok => ok({ value: f() }))"
ffi_newPromise : PrimIO a -> Promise a

%foreign "browser:lambda:(a, f, p) => p.then(x => { f(x.value)(); })"
ffi_runPromise : (a -> PrimIO ()) -> Promise a -> PrimIO ()

%foreign "browser:lambda:(a, b, f, p) => p.then(x => f(x.value).then(y => ({ value: y.value})))"
ffi_thenPromise : (a -> Promise b) -> Promise a -> Promise b

export
runPromise : HasIO io => (a -> IO ()) -> Promise a -> io ()
runPromise f = primIO . ffi_runPromise (\a => toPrim $ f a)

export
execPromise : HasIO io => Promise a -> io ()
execPromise = runPromise $ \_ => pure ()

export
Functor Promise where
    map f = ffi_thenPromise g
        where g : a -> Promise b
              g = ffi_newPromise . prim__io_pure . f

export
Applicative Promise where
    pure = ffi_newPromise . prim__io_pure
    mf <*> my = ffi_thenPromise fx my
        where fx : a -> Promise b
              fx x = ffi_thenPromise (\f => pure $ f x) mf

export
Monad Promise where
    ma >>= f = ffi_thenPromise f ma

export
HasIO Promise where
    liftIO a = ffi_newPromise $ toPrim a
