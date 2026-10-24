module Unfezant.Engine.Assets

import Unfezant.Engine.JS
import Unfezant.Engine.Promise
import Unfezant.Engine.Texture

import Control.Monad.State

export
data UnresolvedAsset : Type where
    Basic : String -> String -> UnresolvedAsset

ToJsObject UnresolvedAsset where
    toJsObject (Basic alias src) = obj $ do
        "alias" :=! alias
        "src" :=! src

interface IsAssetResource a where
    toAssetResource : a -> UnresolvedAsset

export
IsAssetResource String where
    toAssetResource a = Basic a a

export
IsAssetResource (String, String) where
    toAssetResource (a, b) = Basic a b

%foreign "browser:support:assets_load,pixi"
prim_assetsLoad : a -> Promise b

export
loadTexture : IsAssetResource res => res -> Promise Texture
loadTexture res = do
    o <- toJsObject $ toAssetResource res
    prim_assetsLoad o
