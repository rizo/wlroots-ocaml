open Ctypes
open Wlroots_common.Utils
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Xdg_toplevel.t ptr
let t = ptr Types.Xdg_toplevel.t
include Ptr
