module Unfezant.Engine.Eff

%foreign "browser:lambda:(a, args) => console.log(args)"
ffi_consoleLog : a -> PrimIO ()

export
consoleLog : HasIO io => a -> io ()
consoleLog = primIO . ffi_consoleLog
