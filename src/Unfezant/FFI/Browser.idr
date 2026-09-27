module Unfezant.FFI.Browser

%default total

public export
data DomCanvas : Type where

export
data DomBody : Type where

namespace Binding
    export
    %foreign "browser:lambda:() => document.body"
    getDomBody : PrimIO DomBody

export %inline
getDomBody : HasIO io => io DomBody
getDomBody = primIO $ Binding.getDomBody

namespace Binding
    export
    %foreign "browser:lambda:(body, canvas) => body.appendChild(canvas)"
    domBodyAppendChild : DomBody -> DomCanvas -> PrimIO ()

export
domBodyAppendChild : HasIO io => DomBody -> DomCanvas -> io ()
domBodyAppendChild body canvas = primIO $ Binding.domBodyAppendChild body canvas

export
data Promise : Type -> Type where

namespace Binding
    export
    %foreign "browser:lambda:(a, f) => new Promise(ok => ok({ value: f() }))"
    promiseNew : PrimIO a -> Promise a

    export
    %foreign "browser:lambda:(a, f, p) => p.then(x => { f(x.value)(); })"
    promiseRun : (a -> PrimIO ()) -> Promise a -> PrimIO ()

    export
    %foreign "browser:lambda:(a, b, f, p) => p.then(x => f(x.value).then(y => ({ value: y})))"
    promiseFlatMap : (a -> Promise b) -> Promise a -> Promise b

export
Functor Promise where
    map f = Binding.promiseFlatMap g
        where g : a -> Promise b
              g = Binding.promiseNew . prim__io_pure . f

export
Applicative Promise where
    pure = Binding.promiseNew . prim__io_pure
    mf <*> my = Binding.promiseFlatMap fx my
        where fx : a -> Promise b
              fx x = Binding.promiseFlatMap (\f => pure $ f x) mf

export
Monad Promise where
    ma >>= f = Binding.promiseFlatMap f ma

export
mkPromise : IO a -> Promise a
mkPromise action = Binding.promiseNew $ toPrim action

export
runPromise : (a -> IO ()) -> Promise a -> IO ()
runPromise f = primIO . Binding.promiseRun (\a => toPrim $ f a)

export
thenPromise : (a -> Promise b) -> Promise a -> Promise b
thenPromise = Binding.promiseFlatMap

namespace Binding
    export
    %foreign "browser:lambda:(a, args) => console.log(args)"
    consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . Binding.consoleLog
