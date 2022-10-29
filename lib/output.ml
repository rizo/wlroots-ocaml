open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_output.t ptr
include Ptr

let signal_frame (output : t) : t Wl.Signal.t = {
  c = output |-> Types.Wlr_output.events_frame;
  typ = ptr Types.Wlr_output.t;
}

let signal_destroy (output : t) : t Wl.Signal.t = {
  c = output |-> Types.Wlr_output.events_destroy;
  typ = ptr Types.Wlr_output.t;
}

module Mode = struct
  type t = Types.Wlr_output_mode.t ptr
  include Ptr

  let width = getfield Types.Wlr_output_mode.width
  let height = getfield Types.Wlr_output_mode.height
  let refresh = getfield Types.Wlr_output_mode.refresh
  let preferred = getfield Types.Wlr_output_mode.preferred
end

let modes (output : t) : Mode.t list =
  (output |-> Types.Wlr_output.modes)
  |> Bindings.ocaml_of_wl_list
    (container_of Types.Wlr_output_mode.t Types.Wlr_output_mode.link)

let transform_matrix (output : t) : Matrix.t =
  CArray.start (output |->> Types.Wlr_output.transform_matrix)

let set_mode (output : t) (mode : Mode.t): unit =
  Bindings.wlr_output_set_mode output mode

let preferred_mode output =
  let mode = Bindings.wlr_output_preferred_mode output in
  if is_null mode then None else Some mode

let create_global (output : t) =
  Bindings.wlr_output_create_global output

let attach_render (output : t): bool =
  (* TODO: handle buffer age *)
  Bindings.wlr_output_attach_render output (coerce (ptr void) (ptr int) null)

let commit (output : t): bool =
  Bindings.wlr_output_commit output

let enable = Bindings.wlr_output_enable

let init_render (output : t) (allocator : Allocator.t) (renderer : Renderer.t) =
  Bindings.wlr_output_init_render output allocator renderer
