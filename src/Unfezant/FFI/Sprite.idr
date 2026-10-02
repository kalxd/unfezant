module Unfezant.FFI.Sprite

export
data Sprite : Type where

%foreign "browser:support:new_sprite,pixi"
ffi_newSprite : a -> Sprite
