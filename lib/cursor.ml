open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_cursor.t ptr
include Ptr

let create = Bindings.wlr_cursor_create
let attach_output_layout = Bindings.wlr_cursor_attach_output_layout
let attach_input_device = Bindings.wlr_cursor_attach_input_device
let set_surface = Bindings.wlr_cursor_set_surface

let signal_motion (cursor: t) : Pointer.Motion_event.t Wl.Signal.t = {
  c = cursor |-> Types.Wlr_cursor.events_motion;
  typ = Pointer.Motion_event.t;
}

let signal_motion_absolute (cursor: t) :
  Pointer.Motion_absolute_event.t Wl.Signal.t = {
  c = cursor |-> Types.Wlr_cursor.events_motion_absolute;
  typ = Pointer.Motion_absolute_event.t;
}

let signal_button (cursor: t) : Pointer.Button_event.t Wl.Signal.t = {
  c = cursor |-> Types.Wlr_cursor.events_button;
  typ = Pointer.Button_event.t;
}

let signal_axis (cursor: t) : Pointer.Axis_event.t Wl.Signal.t = {
  c = cursor |-> Types.Wlr_cursor.events_axis;
  typ = Pointer.Axis_event.t;
}

let signal_frame (cursor: t) : unit Wl.Signal.t = {
  c = cursor |-> Types.Wlr_cursor.events_frame;
  typ = void;
}
