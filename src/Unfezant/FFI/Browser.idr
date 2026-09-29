module Unfezant.FFI.Browser

%default total

export
data DomCanvas : Type where

export
data DomBody : Type where

export
data DomWindow : Type where

export
data Promise : Type -> Type where

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

%foreign "browser:lambda:(a, f) => new Promise(ok => ok({ value: f() }))"
ffi_newPromise : PrimIO a -> Promise a

%foreign "browser:lambda:(a, f, p) => p.then(x => { f(x.value)(); })"
ffi_runPromise : (a -> PrimIO ()) -> Promise a -> PrimIO ()

%foreign "browser:lambda:(a, b, f, p) => p.then(x => f(x.value).then(y => ({ value: y.value})))"
ffi_thenPromise : (a -> Promise b) -> Promise a -> Promise b

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

export
runPromise : (a -> IO ()) -> Promise a -> IO ()
runPromise f = primIO . ffi_runPromise (\a => toPrim $ f a)

%foreign "browser:lambda:(a, args) => console.log(args)"
ffi_consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . ffi_consoleLog
