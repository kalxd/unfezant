module Unfezant.Engine.Sprite

import Unfezant.Engine.Texture
import Unfezant.Engine.ObservablePoint

export
data Sprite : Type where

%foreign "browser:support:new_sprite,pixi"
prim_newSprite : a -> Sprite

export
mkSprint : Texture -> Sprite
mkSprint = prim_newSprite

%foreign "browser:lambda:(sprite) => sprite.anchor"
prim_anchor : Sprite -> ObservablePoint

export
(.anchor) : Sprite -> ObservablePoint
(.anchor) = prim_anchor

%foreign "browser:lambda:(sprite, x) => sprite.x = x"
prim_setX : Sprite -> Double -> PrimIO ()

export
(.setX) : HasIO io => Sprite -> Double -> io ()
(.setX) sprite x = primIO $ prim_setX sprite x

%foreign "browser:lambda:(sprite, y) => sprite.y = y"
prim_setY : Sprite -> Double -> PrimIO ()

export
(.setY) : HasIO io => Sprite -> Double -> io ()
(.setY) sprite y = primIO $ prim_setY sprite y
