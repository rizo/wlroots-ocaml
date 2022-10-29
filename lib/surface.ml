open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_surface.t ptr
include Ptr

let from_resource = Bindings.wlr_surface_from_resource
let has_buffer = Bindings.wlr_surface_has_buffer

module State = struct
  type t = Types.Wlr_surface_state.t ptr
  include Ptr

  let width = getfield Types.Wlr_surface_state.width
  let height = getfield Types.Wlr_surface_state.height
  let transform = getfield Types.Wlr_surface_state.transform
end

let current = getfield Types.Wlr_surface.current
let pending = getfield Types.Wlr_surface.pending

let send_frame_done = Bindings.wlr_surface_send_frame_done
