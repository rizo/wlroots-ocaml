open Ctypes
open Wlroots_common.Utils

module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Scene.t ptr
include Ptr

module Tree = struct
  type t = Types.Scene.Tree.t ptr
  include Ptr
end
