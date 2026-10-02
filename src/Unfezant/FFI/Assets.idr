module Unfezant.FFI.Assets

import Unfezant.FFI.Promise

%foreign "browser:support:assets_load,pixi"
ffi_assetsLoad : a -> Promise a
