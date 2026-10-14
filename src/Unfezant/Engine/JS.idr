module Unfezant.Engine.JS

%default total

data JsObject : Type where

interface ToJsObject a where
    toJsObject : a -> JsObject

%foreign "browser:lambda:() => ({})"
prim__mkEmptyObj : PrimIO JsObject

mkEmptyObject : HasIO io => io JsObject
mkEmptyObject = primIO prim__mkEmptyObj

%foreign "browser:lambda:(a, args) => console.log(args)"
ffi_consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . ffi_consoleLog
