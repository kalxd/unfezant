module Unfezant.Engine.Assets

import Unfezant.Engine.Promise

%foreign "browser:support:assets_load,pixi"
ffi_assetsLoad : a -> Promise a
