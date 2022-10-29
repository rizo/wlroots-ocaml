open Ctypes
open Wlroots_common.Utils
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_xdg_popup.t ptr
let t = ptr Types.Wlr_xdg_popup.t
include Ptr

let parent = getfield Types.Wlr_xdg_popup.parent
