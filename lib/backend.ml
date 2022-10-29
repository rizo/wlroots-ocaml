open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_backend.t ptr
include Ptr

let autocreate dpy =
  let b = Bindings.wlr_backend_autocreate dpy in
  if is_null b then failwith "Failed to create backend";
  b

let start = Bindings.wlr_backend_start
let destroy = Bindings.wlr_backend_destroy

let signal_new_output (backend: t) : Types.Wlr_output.t ptr Wl.Signal.t = {
  c = backend |-> Types.Wlr_backend.events_new_output;
  typ = ptr Types.Wlr_output.t;
}

let signal_new_input (backend: t) : Types.Wlr_input_device.t ptr Wl.Signal.t = {
  c = backend |-> Types.Wlr_backend.events_new_input;
  typ = ptr Types.Wlr_input_device.t;
}

let signal_destroy (backend: t) : t Wl.Signal.t = {
  c = backend |-> Types.Wlr_backend.events_destroy;
  typ = ptr Types.Wlr_backend.t;
}
