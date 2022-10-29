open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_allocator.t ptr
include Ptr

let autocreate (backend : Backend.t) (renderer : Renderer.t) =
  Bindings.wlr_allocator_autocreate backend renderer
