module Unfezant.FFI.Browser

%default total

public export
record DomCanvas where
    constructor MkDomCanvas
    ptr : AnyPtr

export
data DomBody : Type where

namespace Binding
    export
    %foreign "browser:lambda:() => document.body"
    getDomBody : PrimIO DomBody

export
getDomBody : HasIO io => io DomBody
getDomBody = primIO $ Binding.getDomBody

namespace Binding
    export
    %foreign "browser:lambda:(body, canvas) => body.appendChild(canvas)"
    domBodyAppendChild : DomBody -> AnyPtr -> PrimIO ()

export
domBodyAppendChild : HasIO io => DomBody -> DomCanvas -> io ()
domBodyAppendChild body (MkDomCanvas x) = primIO $ Binding.domBodyAppendChild body x


-- | 不过是另一种EitherT。
export
data PromiseT : Type -> (Type -> Type) -> Type -> Type where

namespace Binding
    export
    %foreign "browser:lambda:(a, e, m, f) => new Promise(ok => { const v = f(); console.log(v); return ok(v); })"
    promiseNew : PrimIO a -> PromiseT e m a

    export
    %foreign "browser:lambda:(e, m, a, b, p, f) => p.then(f)"
    promiseThen : PromiseT e m a -> (a -> PromiseT e m b) -> PromiseT e m b

    export
    %foreign "browser:lambda:(e, m, a, p, f) => p.then(f)"
    promiseRun : PromiseT e m a -> (a -> PrimIO ()) -> PrimIO ()

export
mkPromise : IO a -> PromiseT e m a
mkPromise action = Binding.promiseNew $ toPrim action

export
thenPromise : PromiseT e m a -> (a -> PromiseT e m b) -> PromiseT e m b
thenPromise = Binding.promiseThen

export
runPromise : PromiseT e m a -> (a -> IO ()) -> IO ()
runPromise p f = primIO $ Binding.promiseRun p $ \a => toPrim $ f a

Functor (PromiseT e m) where
    map f p = thenPromise p (\a => mkPromise $ pure $ f a)

namespace Binding
    export
    %foreign "browser:lambda:(a, args) => console.log(args)"
    consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . Binding.consoleLog
