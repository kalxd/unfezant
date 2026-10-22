module Unfezant.Engine.Assets

import Unfezant.Engine.Promise
import Unfezant.Engine.Texture

%foreign "browser:support:assets_load,pixi"
prim_assetsLoad : a -> Promise b

export
loadTexture : String -> Promise Texture
loadTexture = prim_assetsLoad
