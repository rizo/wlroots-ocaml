open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Scene.t ptr
include Ptr

module Tree = struct
  type t = Types.Scene.Tree.t ptr
  include Ptr
end

let create = Bindings.wlr_scene_create

let attach_output_layout (scene : t) (output_layout : Output_layout.t) =
  Bindings.wlr_scene_attach_output_layout scene output_layout
