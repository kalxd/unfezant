module Unfezant.Engine.JS

import Control.Monad.State

%default total

data JsObject : Type where

interface ToJsObject a where
    toJsObject : a -> JsObject

%foreign "browser:lambda:() => ({})"
prim__mkEmptyObj : PrimIO JsObject

mkEmptyObject : HasIO io => io JsObject
mkEmptyObject = primIO prim__mkEmptyObj

%foreign "browser:lambda:(a, obj, key, value) => { obj[key] = value; return obj; }"
prim__setObjectValue : JsObject -> String -> a -> PrimIO JsObject

setObjectValue : HasIO io => String -> a -> JsObject -> io JsObject
setObjectValue key value o = primIO $ prim__setObjectValue o key value

setObjectValue' : HasIO io => String -> Maybe a -> JsObject -> io JsObject
setObjectValue' _ Nothing o = pure o
setObjectValue' key (Just a) o = setObjectValue key a o

export
obj : (HasIO io, Monad io) => StateT JsObject io a -> io JsObject
obj action = do
    init <- mkEmptyObject
    execStateT init action

%foreign "browser:lambda:(a, args) => console.log(args)"
ffi_consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . ffi_consoleLog
