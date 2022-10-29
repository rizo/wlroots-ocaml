open Ctypes
open Wlroots_common.Utils
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Xdg_popup.t ptr
let t = ptr Types.Xdg_popup.t
include Ptr

let parent = getfield Types.Xdg_popup.parent
