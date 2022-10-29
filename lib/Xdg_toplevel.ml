open Ctypes
open Wlroots_common.Utils
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_xdg_toplevel.t ptr
let t = ptr Types.Wlr_xdg_toplevel.t
include Ptr
