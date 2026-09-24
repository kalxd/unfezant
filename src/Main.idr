module Main

%foreign "browser:support:new_application,pixi"
primCreateApplication : PrimIO AnyPtr

%foreign "browser:lambda:console.log"
primConsoleLog : AnyPtr -> PrimIO ()

main : IO ()
main = do
    ptr <- primIO $ primCreateApplication
    primIO $ primConsoleLog ptr
