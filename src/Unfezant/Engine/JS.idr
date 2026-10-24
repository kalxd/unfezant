module Unfezant.Engine.JS

import Control.Monad.State

%default total

%foreign "browser:Math.PI"
prim__MathPi : Double

export
mathPI : Double
mathPI = prim__MathPi

export
data JsObject : Type where

public export
interface ToJsObject a where
    toJsObject : HasIO io => a -> io JsObject

%foreign "browser:lambda:() => ({})"
prim__mkEmptyObj : PrimIO JsObject

mkEmptyObject : HasIO io => io JsObject
mkEmptyObject = primIO prim__mkEmptyObj

%foreign "browser:lambda:(a, obj, key, value) => { obj[key] = value; }"
prim__setObjectValue : JsObject -> String -> a -> PrimIO ()

setObjectValue : HasIO io => String -> a -> JsObject -> io ()
setObjectValue key value o = primIO $ prim__setObjectValue o key value

setObjectValueWhen : HasIO io => String -> Maybe a -> JsObject -> io ()
setObjectValueWhen _ Nothing _ = pure ()
setObjectValueWhen key (Just a) o = setObjectValue key a o

export
obj : HasIO io => StateT JsObject io a -> io JsObject
obj action = do
    init <- mkEmptyObject
    execStateT init action

export infixr 9 :=!

export
(:=!) : HasIO io => String -> a -> StateT JsObject io ()
key :=! value = do
    o <- get
    setObjectValue key value o

export infixr 9 :=?

export
(:=?) : HasIO io => String -> Maybe a -> StateT JsObject io ()
key :=? value = do
    o <- get
    setObjectValueWhen key value o

%foreign "browser:lambda:(a, args) => console.log(args)"
ffi_consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . ffi_consoleLog
